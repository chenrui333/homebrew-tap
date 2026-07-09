class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.91.0.tgz"
  sha256 "8efd95a1d9577cf3da67bdbd7d914deae6f31b546bff28d4fb17a35e8ff311d7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "747d3fe807cadfce4aee3e7a284f2b1dc8400dbfb56e29b3d147ad8964389051"
    sha256 cellar: :any,                 arm64_sequoia: "8d710f981bb638ffa4bb659a0846a3a6e8c906c03d69d2081ebdbf4d45838303"
    sha256 cellar: :any,                 arm64_sonoma:  "8d710f981bb638ffa4bb659a0846a3a6e8c906c03d69d2081ebdbf4d45838303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de0204e3fd1b037daa7b26146699abfeb13a8951043c4e506bd4af4c4172031a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "913cfdcfe8d24735f671902b52871e70ecc5f9988d61e0aca78cb0ad4052453c"
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
