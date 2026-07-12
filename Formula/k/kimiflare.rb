class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.96.1.tgz"
  sha256 "8e1bc64de6b6238f13341ce435715845c991af78a17276970eccec5867c8b02d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c6eb5a3a2da8698d6ba7e7844d35f2b5dff6d098ca0f7f12ec5873a03bdf211e"
    sha256 cellar: :any,                 arm64_sequoia: "93fa40cf1b9b97a73ed5001ecfd9e033a15d061d6f8f48f473b91e3791060d44"
    sha256 cellar: :any,                 arm64_sonoma:  "93fa40cf1b9b97a73ed5001ecfd9e033a15d061d6f8f48f473b91e3791060d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b011d8df7f04701c6f533c4f1dfeacc68dc968a99d4a9b05693a1535ab1ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18cbb6244f2df361e81790ae6c54630a3e0951cb1b154d021a97d0f78f505d9"
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
