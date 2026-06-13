class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.60.1.tgz"
  sha256 "dca7e2572562a8250a639c50ad5ab4c76b07cc81399e96158c41452716222c39"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e29e770b96bed251722d043b08d81798a62d2d5b293c17f4f2fa9b2469a241b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e29e770b96bed251722d043b08d81798a62d2d5b293c17f4f2fa9b2469a241b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e29e770b96bed251722d043b08d81798a62d2d5b293c17f4f2fa9b2469a241b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8e950b09fbf75201f85aa2e4a697cb8a2443d7ae153727bbf17f6340d94d5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afc949aad10793c5903f8ee6936017893b5008d8b26a0c55e6b4a389f9c9dcb6"
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
