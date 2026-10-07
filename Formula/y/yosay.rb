class Yosay < Formula
  desc "Tell Yeoman what to say"
  homepage "https://github.com/yeoman/yosay"
  url "https://registry.npmjs.org/yosay/-/yosay-3.0.0.tgz"
  sha256 "5407cc98e1329d78f3e143ceeed6da82d8d75cf92a71700878ab40dbe711bb59"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dc4c5568b6516662da32b8d4543c5796ff40edc568e3748c68df99ac33005a47"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/yosay"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yosay --version")
    assert_match "Hello, Homebrew!", shell_output("#{bin}/yosay 'Hello, Homebrew!'")
  end
end
