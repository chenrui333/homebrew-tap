class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.99.0.tgz"
  sha256 "d8905d1a9f3c2274a28e5901b50d3625c3e0af7ce468c1fbba6a255ef0ff6d5d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "836aef28c7c6749e7d3eb19b8f93ca1b39b2eb4fde9fb17f766dc5aa04d636b9"
    sha256 cellar: :any,                 arm64_sequoia: "836aef28c7c6749e7d3eb19b8f93ca1b39b2eb4fde9fb17f766dc5aa04d636b9"
    sha256 cellar: :any,                 arm64_sonoma:  "836aef28c7c6749e7d3eb19b8f93ca1b39b2eb4fde9fb17f766dc5aa04d636b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98b914c449ac32d53d21c953ebb1aa71a0d98e17dc26cf79d96d1e33539ba2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b43033280a4969dc98cbfec81b6c1a87ed6f6246a52286e0f77d4b21640fd3"
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
