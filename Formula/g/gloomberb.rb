class Gloomberb < Formula
  desc "Extensive financial terminal, in your terminal"
  homepage "https://github.com/gloom-sh/gloomberb"
  url "https://github.com/gloom-sh/gloomberb/archive/refs/tags/v0.20.23.tar.gz"
  sha256 "cfe5b7285b8a3705519fcb47aab1296de82b9c1d577ec5c7391ef91b2384c5f4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "a20ab3ab8fab9631ad547c9729fa735c1486f7912c883ffdb77fc4f50e16b454"
    sha256 arm64_tahoe:   "e73c9575a66e6325bb0eef7cd8784f52f974fc84cd3123ad24a8ebd8ea707880"
    sha256 arm64_sequoia: "506447448fbda5c11b5a08adbcbf665918faf6dcf5670cfed0842cfa000bfc3e"
    sha256 arm64_linux:   "57b83072e287d6bb86ae757d7e8e46d4bb8d4bead0b3f2980d3dd3336734c6f5"
    sha256 x86_64_linux:  "c43b0f9295dc85356999538a0876faefd4e82105673e3a43ee446462b00f82e1"
  end

  depends_on "bun" => :build
  depends_on "zig@0.15" => :build

  on_linux do
    # Standalone executables retain the brewed Bun runtime template's ICU linkage.
    depends_on "icu4c@79"

    on_intel do
      depends_on "qemu" => :build
    end
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
    native_arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    native_os = OS.mac? ? "macos" : "linux"
    native_target = "#{native_arch}-#{native_os}"
    zig_target = OS.linux? ? "#{native_target}-gnu.2.17" : native_target
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
             "-Dtarget=#{zig_target}", "-Doptimize=ReleaseFast", "-j#{ENV.make_jobs}"
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
    # Use the brewed runtime instead of downloading a separate executable template.
    ENV["BUN_COMPILE_EXECUTABLE_PATH"] = bun
    if OS.linux? && Hardware::CPU.intel?
      # Bun treats -baseline as a download target even though brewed Bun already supports that CPU.
      inreplace "scripts/build.ts", "const target = bunTarget(targetConfig);", 'const target = "bun-linux-x64";'

      # Run the Nehalem smoke check against the brewed binary and host libraries without a container.
      inreplace "scripts/build.ts" do |s|
        s.gsub! "const oldCpu = await oldCpuRunner(runner, smokeDir, emulator);",
                'const oldCpu = Bun.which("qemu-x86_64");'
        s.gsub! <<-OLD, <<-NEW
      runner: oldCpu,
      runnerIsContainer: true,
      command: CONTAINER_EMULATOR,
        OLD
      runner: [],
      command: oldCpu,
        NEW
      end
    end
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
