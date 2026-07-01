class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.89.0.tgz"
  sha256 "fa4efe264dc308f8c517561313d4e8e28b9d6e6098aa0ef85184c79ced6a6d54"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "78bc0e575674cd6ec45ab00571007acf67394674b2f1f8a10a5b7d1abfbf62d1"
    sha256 cellar: :any,                 arm64_sequoia: "b9ff7ecaea0bf175f36e97fa5d5f102709fe0ceb16632e88e020743843db0547"
    sha256 cellar: :any,                 arm64_sonoma:  "b9ff7ecaea0bf175f36e97fa5d5f102709fe0ceb16632e88e020743843db0547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "889c3a62f85d7586a115a34a90f60bed4630a65ddebbf0d46fd5d60f80164719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c7fd01d6bdb9adf499860dd117357b447a9dcc547b214b5edf003e69501f2f"
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
