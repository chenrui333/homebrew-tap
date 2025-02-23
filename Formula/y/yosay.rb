class Yosay < Formula
  desc "Tell Yeoman what to say"
  homepage "https://github.com/yeoman/yosay"
  url "https://registry.npmjs.org/yosay/-/yosay-3.0.0.tgz"
  sha256 "5407cc98e1329d78f3e143ceeed6da82d8d75cf92a71700878ab40dbe711bb59"
  license "BSD-2-Clause"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/yosay"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yosay --version")
    assert_match "Hello, Homebrew!", shell_output("#{bin}/yosay 'Hello, Homebrew!'")
  end
end
