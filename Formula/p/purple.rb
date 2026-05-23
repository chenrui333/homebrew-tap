class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "43a083bd89f0910251d333c230817790129bd106adfd30fdbb8393b45f111fcf"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "202a646d7ca9813a86bc273a2e0b0dad6b1aae1331d1f5e6f337396094d6fa55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e8b53890aef1cfdc357ecbc1ff6f0079235e463a49f1fab549ad673fc9ac31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c49e31601ef74b20d2ca0891d8f034733231c796b1766514649cadb5ec0df14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c557da41558f301762208abf82272e59050df53539f01617193afe6ee2449ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea3704b11bd936fa97f4e477a87944248e08747a67d000e1a279c1cba4218f2"
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
