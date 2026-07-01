class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.89.0.tgz"
  sha256 "fa4efe264dc308f8c517561313d4e8e28b9d6e6098aa0ef85184c79ced6a6d54"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4f99d025d6a2cc0afa7f34fff354b08addadd6c8d4b7002749d86d80d484ce6f"
    sha256 cellar: :any,                 arm64_sequoia: "958b6bb3ef1c105efff819b737cc7eecf763bdd7b894041c05fdf790b50adbf6"
    sha256 cellar: :any,                 arm64_sonoma:  "958b6bb3ef1c105efff819b737cc7eecf763bdd7b894041c05fdf790b50adbf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "933391b176ad34c3b86b7b4c514e256aef3f5b2e5c6ced25674310881a4ebc5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad9e246523b6dd17239fdbbc6a9fa8d20bf531ee7b8665faa766c61c8daedee"
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
