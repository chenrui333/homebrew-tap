class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.14.5.tar.gz"
  sha256 "98509a118f9dccf81e86ae1110b37b15a68578eb6837a53a93958dc8b9b7d5b7"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a1bef79abfd0979486c4b2b184e0cdd2c233c774403cb483d375c095bfdb649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebeee9b325cc9f368b763d68397fe1e21320a8eafef6ec2ed320c42e0bc4a3d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd4cfc9a3e3174810bdaa09101be13d73dc021c9c6a9cff00be7bf0758f5eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74bcfa6924f5eb5e02053263dac6f9e71bf7f7cc2b1676c6cee54c6d4e00e97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b5315dd72dec24d4c9e221b0913e0eb05d3d0d555bce48c617b070c0f44bfb"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
