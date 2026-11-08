class Gloomberb < Formula
  desc "Extensive financial terminal, in your terminal"
  homepage "https://github.com/gloom-sh/gloomberb"
  url "https://github.com/gloom-sh/gloomberb/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "ad2786328b420a6221a779b5efe7c44e87f36eda939fb8fbdd87ecc2c71d72c3"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0b17f6ca397c3206fa206074e4895e446d425743e91dcf9adb73634326786807"
    sha256                               arm64_sequoia: "0b17f6ca397c3206fa206074e4895e446d425743e91dcf9adb73634326786807"
    sha256                               arm64_sonoma:  "0b17f6ca397c3206fa206074e4895e446d425743e91dcf9adb73634326786807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f68437e19c2c79b0e6fa8cc467ec65d2a18eb4a632f2590d81f325a3f3d15fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31da9ea143e597aa4b626debdaf3fa2ee09a4f789b3461b7015fb05f70a43908"
  end

  depends_on "bun" => :build
  depends_on "zig@0.15" => :build

  on_linux do
    # Standalone executables retain the brewed Bun runtime template's ICU linkage.
    depends_on "icu4c@79"
  end

  resource "opentui-native" do
    url "https://github.com/anomalyco/opentui/archive/8cb2a5ae0023d01b6fe1235c71b13d9857d17b6f.tar.gz"
    sha256 "3ba05e89bfd5b06fd554cea02f28b26895cab6e53d6ec9bca16634c1b6d75165"
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
      system formula_opt_bin("zig@0.15")/"zig", "build", "-Dtarget=#{native_target}",
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
    # Use the brewed runtime instead of downloading a separate Bun executable template.
    ENV["BUN_COMPILE_EXECUTABLE_PATH"] = bun
    system bun, "run", "build"
    output = "dist/gloomberb-#{platform}-#{arch}"
    system "gunzip", "#{output}.gz"
    bin.install output => "gloomberb"
  end

  test do
    # FIXME: Upstream has no version command; its help header exposes the release version.
    assert_match version.to_s, shell_output("#{bin}/gloomberb help")
    output = shell_output("#{bin}/gloomberb ticker 2>&1", 1)
    assert_match "Usage: gloomberb ticker <symbol>", output
  end
end
