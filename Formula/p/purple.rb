class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "b120671b5f0cde28c88a741f5115b9f24b889fdf87820a24ff4c15bdbcbcf94d"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c6dd8fcc2ae644b5001cf97218f43abf3ffd58377a2c8a6383af5083e7b1d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5880b20d62eaa5fe12f355a698d79842535d25607e37a7b999efa330ec04f00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723ca5af11107d059faa53488922ad33ac42a7b347089e193bb56a2ec33413a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15701d9d5331969103976895d24473f40baff9cf181f541ba8ec67f66c6e8e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249ffab466ce7bb87d8be35c108d7bf165b8dcb732a3f602716de6895e11a46b"
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
