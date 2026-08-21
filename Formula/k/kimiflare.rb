class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.99.0.tgz"
  sha256 "d8905d1a9f3c2274a28e5901b50d3625c3e0af7ce468c1fbba6a255ef0ff6d5d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c390150325efcff9f304a779980df7aa1878e84e01cdc3cd71109d6e243e3f44"
    sha256 cellar: :any,                 arm64_sequoia: "c390150325efcff9f304a779980df7aa1878e84e01cdc3cd71109d6e243e3f44"
    sha256 cellar: :any,                 arm64_sonoma:  "c390150325efcff9f304a779980df7aa1878e84e01cdc3cd71109d6e243e3f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b08088f519d38cf7e939bb7e002b8f3106ad02341e20e91b2ffd7ca3c538d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a25d67b82a3cfdc40dd4eaf007896e3e2bf661a8fd0fb6849efd681835e2376d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    prebuilds = libexec/"lib/node_modules/kimiflare/node_modules/isolated-vm/prebuilds"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    keep = "#{platform}-#{arch}"
    if prebuilds.directory?
      prebuilds.children.each { |dir| rm_r(dir) if dir.basename.to_s != keep }
      (prebuilds/keep).glob("*.musl.node").each(&:unlink) if OS.linux?
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimiflare --version")
    output = shell_output("#{bin}/kimiflare --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
