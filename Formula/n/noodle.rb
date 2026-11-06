class Noodle < Formula
  desc "Terminal REST client"
  homepage "https://github.com/wilfredinni/noodle"
  url "https://github.com/wilfredinni/noodle/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "e00a6cc6e01c57dc49e3c9ffa004f88daf6d77d9043674b257aa5b5c59e25c63"
  license "Apache-2.0"
  head "https://github.com/wilfredinni/noodle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "03f19b3215e5a693feb8c4bd24b373afa22cf486cc985fbbef998edd05cbb26f"
    sha256 cellar: :any,                 arm64_sequoia: "802033a47c2b180e9ba7ac2697ce7e90938b94731633135eb39d77c8a84d8d76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9c0bc6bb5b1bbdd86caf8a8f0d099cc57858e5fc8b3c6958dac9dff055c6972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d55b529e36256b65ec3041962b41c9232279e1b9ffcf01d1d0a744217f06ac"
  end

  depends_on "zig@0.16" => :build
  depends_on "bun"

  resource "opentui" do
    url "https://github.com/anomalyco/opentui/archive/refs/tags/v0.5.9.tar.gz"
    sha256 "5aaa05506cbaf3318d3977dd09f42f9864ba8ee3a86a98c1f65a020b62479e9b"
  end

  deny_network_access!

  def fetch
    # Husky installs development Git hooks and is not a production dependency.
    package = JSON.parse((buildpath/"package.json").read)
    package.fetch("scripts").delete("prepare")
    (buildpath/"package.json").atomic_write JSON.generate(package)
    system "bun", "install", "--frozen-lockfile", "--production"
  end

  def install
    libexec.install "src", "assets", "scripts", "node_modules", "package.json"
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
