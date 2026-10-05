class Litespeed < Formula
  desc "Local coding agent with multi-model workflows for terminal and browser"
  homepage "https://github.com/BerriAI/litespeed"
  url "https://github.com/BerriAI/litespeed/archive/refs/tags/v0.1.23.tar.gz"
  sha256 "1a0327dec9d8c9f40fa31cc0ab467d3a0ba9f02fa3fbfe7c3f0a682200d2266f"
  license "Apache-2.0"
  head "https://github.com/BerriAI/litespeed.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "916e4847a386c7c39b7814dfdd863bda910897049adb39c377fedad54a6a405f"
    sha256 cellar: :any, arm64_sequoia: "6ad9da4c4f96343badd1d3bbb3254a1e42640786302e8e47becd6d303caf0a1c"
    sha256 cellar: :any, arm64_linux:   "25e43eeaa38c2c03048ba920f0cead9207b31913d5f495b34b8e6087e6b6ef42"
    sha256 cellar: :any, x86_64_linux:  "24419972e1a6c3819f888a0d1f5fb282c3ac5ea06f53326c208f46b32f4806fb"
  end

  depends_on "zig@0.16" => :build
  depends_on "node"

  resource "opentui" do
    url "https://github.com/anomalyco/opentui/archive/refs/tags/v0.5.11.tar.gz"
    sha256 "5c6263fccc41d2dce7dbfde0cdf358000d44c745bbde8a44013bcfc6674c0788"
  end

  deny_network_access!

  def fetch
    system "npm", "ci", "--no-audit", "--no-fund"
  end

  def install
    ENV.prepend_path "PATH", formula_opt_bin("node")
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
          old = "    });\n\n    " \
                "if (target.result.os.tag == .linux and optimize != .Debug) lib.build_id = .sha1;"
          new = "    });\n\n    " \
                "if (target.result.os.tag == .macos) lib.headerpad_max_install_names = true;\n    " \
                "if (target.result.os.tag == .linux and optimize != .Debug) lib.build_id = .sha1;"
          inreplace "build.zig", old, new
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
