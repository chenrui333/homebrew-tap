class Gloomberb < Formula
  desc "Extensive financial terminal, in your terminal"
  homepage "https://github.com/gloom-sh/gloomberb"
  url "https://github.com/gloom-sh/gloomberb/archive/refs/tags/v0.20.12.tar.gz"
  sha256 "722f197b3de52284cbc5a7b93a92fa82720e1e3c1490e9b0c7d26bd00f6f4409"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "85aebef9484134b1254f9358ed9602de2910a5d5ce9bdb45ca5df764f38d0c30"
    sha256 arm64_sequoia: "9190985cbcee43c88c419121d8efa171435c89b7497d76eed95268495c21217d"
    sha256 arm64_linux:   "cac9cba03c6dbb8aa1adbf3714175606dc1c90e04e13bd025d2e0b5ef7980ab2"
    sha256 x86_64_linux:  "166635ee2e983d55ab16b8baa407d28f7bc71584fd73937ae1478e863ca81181"
  end

  depends_on "bun" => :build
  depends_on "zig@0.15" => :build

  on_linux do
    # Standalone executables retain the brewed Bun runtime template's ICU linkage.
    depends_on "icu4c@79"
  end

  resource "opentui-native" do
    url "https://github.com/anomalyco/opentui/archive/0d449d4c170a703197f0321f48c7e3bd38dcbd31.tar.gz"
    sha256 "33aab267403fc2626c0fb051341852bf080a5f2e2252d38615cd4312ecbbe28a"
  end

  deny_network_access!

  def fetch
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--production", "--ignore-scripts"
    resource("opentui-native").stage(buildpath/"opentui-native")
    cd "opentui-native/packages/core/src/zig" do
      system formula_opt_bin("zig@0.15")/"zig", "build", "--fetch"
    end
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    native_name = OS.mac? ? "libopentui.dylib" : "libopentui.so"
    native_target = "#{Hardware::CPU.arm? ? "aarch64" : "x86_64"}-#{OS.mac? ? "macos" : "linux"}"
    native_root = buildpath/"opentui-native/packages/core/src/zig"
    cd native_root do
      # Reserve Mach-O load-command space for Homebrew's install-name relocation.
      inreplace "build.zig", <<-OLD, <<-NEW
    const install_dir = b.addInstallArtifact(lib, .{
      OLD
    if (target.result.os.tag == .macos) lib.headerpad_max_install_names = true;

    const install_dir = b.addInstallArtifact(lib, .{
      NEW
      # Match the SDK's glibc ABI; an ABI-less Linux target links musl's libc.so.
      system formula_opt_bin("zig@0.15")/"zig", "build",
             "-Dtarget=#{native_target}#{"-gnu.2.17" if OS.linux?}",
             "-Doptimize=ReleaseFast", "-j#{ENV.make_jobs}"
    end
    host_libraries = buildpath.glob("**/node_modules/@opentui/core-#{platform}-#{arch}/#{native_name}",
                                   File::FNM_DOTMATCH)
    odie "OpenTUI host library was not installed" if host_libraries.empty?
    host_libraries.each { |library| cp native_root/"lib/#{native_target}/#{native_name}", library }
    buildpath.glob("**/node_modules/@opentui/core-*", File::FNM_DOTMATCH).each do |pkg|
      next if pkg.basename.to_s == "core-#{platform}-#{arch}"

      rm_r pkg if pkg.exist? || pkg.symlink?
    end
    # Resolve only the source-built host SDK library, not optional release-platform imports.
    inreplace "scripts/build.ts", "`--target=${target}`, compileEntry,", <<~JS.chomp
      `--target=${target}`,
      `--define=process.platform=${JSON.stringify(process.platform)}`,
      `--define=process.arch=${JSON.stringify(process.arch)}`,
      '--define=process.env.OPENTUI_LIBC="glibc"', compileEntry,
    JS
    # Use the brewed runtime instead of downloading a separate Bun executable template.
    ENV["BUN_COMPILE_EXECUTABLE_PATH"] = bun
    system bun, "run", "build", "--target", "#{platform}-#{arch}"
    output = "dist/gloomberb-#{platform}-#{arch}"
    system "gunzip", "#{output}.gz"
    bin.install output => "gloomberb"
    bin.install_symlink "gloomberb" => "gloom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gloom version")
    output = shell_output("#{bin}/gloomberb ticker 2>&1", 1)
    assert_match "Usage: gloom ticker <symbol>", output
  end
end
