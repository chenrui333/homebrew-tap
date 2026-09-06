class Noodle < Formula
  desc "Terminal REST client"
  homepage "https://github.com/wilfredinni/noodle"
  url "https://github.com/wilfredinni/noodle/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "16187ef194664548eb7e220209a2f1e0633e339760425eced2ee3a4d8db8c383"
  license "Apache-2.0"
  head "https://github.com/wilfredinni/noodle.git", branch: "main"

  depends_on "zig" => :build
  depends_on "bun"

  resource "opentui" do
    url "https://github.com/anomalyco/opentui/archive/refs/tags/v0.5.9.tar.gz"
    sha256 "5aaa05506cbaf3318d3977dd09f42f9864ba8ee3a86a98c1f65a020b62479e9b"
  end

  def install
    # Husky installs development Git hooks and is not a production dependency.
    package = JSON.parse((buildpath/"package.json").read)
    package.fetch("scripts").delete("prepare")
    (buildpath/"package.json").atomic_write JSON.generate(package)
    system "bun", "install", "--frozen-lockfile", "--production"
    libexec.install "src", "assets", "node_modules", "package.json"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    libexec.glob("node_modules/@opentui/core-*").each do |path|
      rm_r path unless path.basename.to_s.end_with?("-#{os}-#{arch}")
    end
    # Build the FFI library from source with room for Homebrew bottle relocation.
    native_package = libexec/"node_modules/@opentui/core-#{os}-#{arch}"
    resource("opentui").stage do
      cd "packages/native" do
        system "sh", "scripts/prepare-zig-deps.sh"
        inreplace "build.zig", "    addNativeAudioDependencies(b, module, target, macos_sdk_path);",
                              "    if (target.result.os.tag == .macos) lib.headerpad_max_install_names = true;\n    " \
                              "addNativeAudioDependencies(b, module, target, macos_sdk_path);"
        system "zig", "build", "-Doptimize=ReleaseFast"
        library = "libopentui.#{OS.mac? ? "dylib" : "so"}"
        rm native_package/library
        native_package.install Dir["lib/*/#{library}"]
      end
    end
    (bin/"noodle").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/src/app/cli.ts" "$@"
    SH
    chmod 0755, bin/"noodle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noodle --version")
    output = shell_output("#{bin}/noodle workspace list")
    assert_match "collection", output.downcase
  end
end
