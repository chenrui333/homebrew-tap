class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.31.1.tar.gz"
  sha256 "a6a4612b56c6857f82ffab17945b27323cfed8930840a8d41ee221ef55dc1176"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "697fd61d1db9a6dd8ab5137bc581b4d5cb25375c25da8d59931878592731475a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "696e949e6488eb983e006c5eaad0d6e29e303efeb7e507307f663d8ebb9bf477"
    sha256 cellar: :any,                 arm64_linux:   "972b0584b96ebeb1cd11116695321195175772c6e750f98e8ebe65072bb62497"
    sha256 cellar: :any,                 x86_64_linux:  "8f222e5f474833d0087257a139df1db4279b30f6ccb8f8c56b12b8ab72cfc743"
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
