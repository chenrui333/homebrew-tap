class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.90.0.tgz"
  sha256 "e31c337fbd235e7baf00a2adc6073d45bde8cecc87f41ee923ce7d925e5ee3d0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1c626fea46e0756ca2eaeb93b7f41b19bf5a5c4dd9303b01d751948970a7ff06"
    sha256 cellar: :any,                 arm64_sequoia: "12977330d58a17ab3cdc53fc3794d5f87d85c13f74a020466d66c30c9282fe02"
    sha256 cellar: :any,                 arm64_sonoma:  "12977330d58a17ab3cdc53fc3794d5f87d85c13f74a020466d66c30c9282fe02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c9c76cd7f27a11c5bdcde0c03d04f1a46a46f2820ade65b63b3ac61e11d7154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d00d66d850475c6c4fda6e7891789e6f24b45865a72a628645fe1012e6ad67"
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
