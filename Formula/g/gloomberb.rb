class Gloomberb < Formula
  desc "Extensive financial terminal, in your terminal"
  homepage "https://github.com/gloom-sh/gloomberb"
  url "https://github.com/gloom-sh/gloomberb/archive/refs/tags/v0.20.13.tar.gz"
  sha256 "4079c01bbbcd40d4f07e023fe17d6bb6340a68f0ddaff899ff3c71dffe45ac0d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "f09d6752200df6fe17a5fa03a21ec2a67e1d092a6ecb5adf7791f5a11c360418"
    sha256 arm64_sequoia: "95b0b163e6028a205cc435ae91e3276d1456cc991d205095fc0b883e873c8f3f"
    sha256 arm64_linux:   "dec203cad949749f3ef1826af539c6691a867bf69dd5fc6e1362afe174de4226"
    sha256 x86_64_linux:  "16a11fb7fed0131f841970337536c6c6812189d320e5ccf6e575719e1daa335c"
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
