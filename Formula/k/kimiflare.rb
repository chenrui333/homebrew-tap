class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.97.0.tgz"
  sha256 "e868cfa589093c83e3b46b3fbdc423ab9f5cff4e1da7c6af9d0ed4bb50d7ed80"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "24acdac37ebbf2b5bba875c6f3085739c51914ea220d408c137fde0f77247623"
    sha256 cellar: :any,                 arm64_sequoia: "24acdac37ebbf2b5bba875c6f3085739c51914ea220d408c137fde0f77247623"
    sha256 cellar: :any,                 arm64_sonoma:  "24acdac37ebbf2b5bba875c6f3085739c51914ea220d408c137fde0f77247623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3352f2ac3a1a565253b9e2134437bfe3232b6b89fb45ffc6eb33372065320313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c7dd1398941a7f1d967eefd2920cf7d031728f2dfe0c370e75529189c1a192"
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
