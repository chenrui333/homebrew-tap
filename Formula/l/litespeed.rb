class Litespeed < Formula
  desc "Local coding agent with multi-model workflows for terminal and browser"
  homepage "https://github.com/BerriAI/litespeed"
  url "https://github.com/BerriAI/litespeed/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "2edc9f4a62a3466d4e9c466313b561ed3d43889716bfaf4101a07ff6986202ef"
  license "Apache-2.0"
  head "https://github.com/BerriAI/litespeed.git", branch: "main"

  depends_on "zig" => :build
  depends_on "node"

  resource "opentui" do
    url "https://github.com/anomalyco/opentui/archive/refs/tags/v0.5.11.tar.gz"
    sha256 "5c6263fccc41d2dce7dbfde0cdf358000d44c745bbde8a44013bcfc6674c0788"
  end

  def install
    ENV.prepend_path "PATH", formula_opt_bin("node")
    system "npm", "ci", "--no-audit", "--no-fund"
    system "npm", "run", "build"
    system "npm", "prune", "--omit=dev"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}"

    node_pty_prebuilds = buildpath/"node_modules/node-pty/prebuilds"
    if node_pty_prebuilds.exist?
      node_pty_prebuilds.each_child do |path|
        rm_r path if path.basename.to_s != native
      end
    end

    buildpath.glob("node_modules/@opentui/core-*").each do |path|
      rm_r path if path.basename.to_s != "core-#{native}"
    end

    # Bun is used only by upstream's release-packaging script; do not ship its prebuilt runtime.
    rm_r buildpath/"node_modules/bun"
    rm_r buildpath/"node_modules/@oven"
    rm buildpath/"node_modules/.bin/bun" if (buildpath/"node_modules/.bin/bun").exist?
    rm buildpath/"node_modules/.bin/bunx" if (buildpath/"node_modules/.bin/bunx").exist?

    libexec.install "bin", "dist", "node_modules", "package.json", "LICENSE", "THIRD_PARTY_NOTICES.md"

    # Rebuild OpenTUI's native library with room for Homebrew bottle relocation.
    native_package = libexec/"node_modules/@opentui/core-#{native}"
    resource("opentui").stage do
      cd "packages/native" do
        system "sh", "scripts/prepare-zig-deps.sh"
        if OS.mac?
          inreplace "build.zig", <<~ZIG, <<~ZIG
            const lib = b.addLibrary(.{
                .name = LIB_NAME,
                .root_module = module,
                .linkage = .dynamic,
            });
          ZIG
            const lib = b.addLibrary(.{
                .name = LIB_NAME,
                .root_module = module,
                .linkage = .dynamic,
            });
            if (target.result.os.tag == .macos) lib.headerpad_max_install_names = true;
          ZIG
        end
        system "zig", "build", "-Doptimize=ReleaseFast"
        library = "libopentui.#{OS.mac? ? "dylib" : "so"}"
        rm native_package/library
        native_package.install Dir["lib/*/#{library}"]
      end
    end

    (bin/"litespeed").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/bin/litespeed.mjs" "$@"
    SH
    chmod 0755, bin/"litespeed"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/litespeed --version")

    output = shell_output("#{bin}/litespeed --not-a-real-option 2>&1", 1)
    assert_match "Unknown option: --not-a-real-option", output
  end
end
