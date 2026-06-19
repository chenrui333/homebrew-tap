class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.88.3.tgz"
  sha256 "34f0ca3edf7a6323b9e195057a6e877ba81e62fcb9e75d1955de3d6125431a1c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b324f67a4203e5afe70106e332de638b80f9e04e1a38b1aab753ec3c2556f2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b324f67a4203e5afe70106e332de638b80f9e04e1a38b1aab753ec3c2556f2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b324f67a4203e5afe70106e332de638b80f9e04e1a38b1aab753ec3c2556f2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0318a040b839d5f84a210a3d3f06959e7bf8244b02a83c7a5515be34f5b51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76057f9c4ad148fa3d23274691cf6ee0675851432c23e652518fdbc306879666"
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
