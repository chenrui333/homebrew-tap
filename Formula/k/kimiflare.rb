class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.88.4.tgz"
  sha256 "49d5384620ce821b43d2c79e05043dede4178cff190cc33d2dcde7d9bc01848a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2062bad6d3a2afbbc77ae4e89de14b7310965f7b876b5d6f79516ec78fc5926a"
    sha256 cellar: :any,                 arm64_sequoia: "2deb9648b4b59814a1c1626318f07f23bdf5e4bcbeb320f150007ad9fcba3b11"
    sha256 cellar: :any,                 arm64_sonoma:  "2deb9648b4b59814a1c1626318f07f23bdf5e4bcbeb320f150007ad9fcba3b11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "958a836a0eea9b5d13c2b545b88f68310066dcb0b4f0585249b2df513ff9a971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29ec53379558c0d0ea1b5772bd1f4bf8563ef77f1c6e8f77e4af20ecdeb5c30d"
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
