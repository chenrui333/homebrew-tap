class Noodle < Formula
  desc "Terminal REST client"
  homepage "https://github.com/wilfredinni/noodle"
  url "https://github.com/wilfredinni/noodle/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "17fd3d8465b37d07c7eed8769159744c4684bc46a07bb60baef77d4bb7daae56"
  license "Apache-2.0"
  head "https://github.com/wilfredinni/noodle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8fcc243b2d9a202d1f6be557faffb6d21b778e1cdb447c021fb4d2d97548fdf0"
    sha256 cellar: :any,                 arm64_sequoia: "c906144be9d703019fff2b6495b36a283b935d714bfccd5e818f0a8839294294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a3562843477177dac99fa5769dd39f67afddeb957f3aac3269a0ef63291bea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a683c1baa802aa52c40633227d5aaa83b425a6895fd12163a8727c4a3ca31a5"
  end

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
    (libexec/".agents/skills").install ".agents/skills/noodle-use"
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
        inreplace "build.zig", "addNativeAudioDependencies(b, module, target, macos_sdk_path);", <<~ZIG
          if (target.result.os.tag == .macos) lib.headerpad_max_install_names = true;
          addNativeAudioDependencies(b, module, target, macos_sdk_path);
        ZIG
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
