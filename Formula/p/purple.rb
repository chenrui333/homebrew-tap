class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.31.1.tar.gz"
  sha256 "a6a4612b56c6857f82ffab17945b27323cfed8930840a8d41ee221ef55dc1176"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bb737576da2a0d9263452d6788e2e20922c5557e374c0b90cdf598d6b40f50f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ab2261d68f15406a7089e22edcfc4daae6a248dbcda59c480fbcd45459eff5"
    sha256 cellar: :any,                 arm64_linux:   "37b260771b9b814653a51bc3eb146ee1b3918afda8ab2aef96b570ff59d8aeda"
    sha256 cellar: :any,                 x86_64_linux:  "c4144320b67b646dda5245189c2ef2c850ffbf9ff38d3268ddff4cc4933f15ab"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")

    (testpath/"ssh_config").write <<~EOS
      Host tap-test
        HostName 127.0.0.1
        User nobody
    EOS

    output = shell_output("#{bin}/purple --list --config #{testpath}/ssh_config")
    assert_match "tap-test", output
  end
end
