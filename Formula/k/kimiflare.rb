class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.96.1.tgz"
  sha256 "8e1bc64de6b6238f13341ce435715845c991af78a17276970eccec5867c8b02d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f186304af220e44620f1618405254af4fe5e97e398bb4c9676d7052790ec7d3a"
    sha256 cellar: :any,                 arm64_sequoia: "ab94e4e999be2a7dad98fa2b370f1a7561c66e6eb701948134d47d9c0a3c29d2"
    sha256 cellar: :any,                 arm64_sonoma:  "ab94e4e999be2a7dad98fa2b370f1a7561c66e6eb701948134d47d9c0a3c29d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6115dccbaa66a25337aa1c36c4490058690832433f5861923c9423040ccd8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24fdbd09be959eee912475eed521c2aeae3ae92a52df9d6154f26d8ad5b59aa9"
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
