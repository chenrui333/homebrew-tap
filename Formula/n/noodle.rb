class Noodle < Formula
  desc "Terminal REST client"
  homepage "https://github.com/wilfredinni/noodle"
  url "https://github.com/wilfredinni/noodle/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "fb2f68c9b58ddbe1e7a44866a51eb8e01bf94a19d3489a68196ebaffa8ee5eef"
  license "Apache-2.0"
  head "https://github.com/wilfredinni/noodle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c6044cd4bb81d70f10a5ea1c1f414a2a938f9c4e3dba6f30326e4ac63f74a982"
    sha256 cellar: :any,                 arm64_sequoia: "a3b238dd719207317899bed6a72c27a71b1e3c7d446d101ef31ff8fafdf1ad4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8477aa3a882f425f60617bf684420ac871bf99e12a23a76a9c0f239a1ae1bbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38fccf5ba01e75d789e10adf18c469c1eb48d4057374b21ae603fd5c0165338a"
  end

  depends_on "zig@0.16" => :build
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
