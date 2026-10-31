class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.33.0.tar.gz"
  sha256 "faef1b409841f2e18cecdd6f2d06c69116901113097b53ac8d24a30c594fed31"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cb2d6578ead35d3af26cada67c5e7da26fdfa564a73ef35d1efe018b12cc4cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44fc6d57eb27d5acacc652d9f7f519c18439770b7d5937471c3bb3ece41d8cc5"
    sha256 cellar: :any,                 arm64_linux:   "abdb8401377d8a2345d4e8cc7a37e9bf1f50e61a2209cc2d0ffc3cdb40dbef57"
    sha256 cellar: :any,                 x86_64_linux:  "5e86d2c32c2d9a25af79d2f70929970b656baf2ad890052e6b9a7d05cc327be6"
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
