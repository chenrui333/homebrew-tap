class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "ec8be89267ee0e7bd44eae6d4d1c2e43affee25e7376f9b36a8a95ae3eff50c3"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f0bb5fb4a6f03b752eccccb256820244e9b7396809c40b3190857ad324e2e03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd495e8d10d2e31c081114ab181f6a6479d7230afe72313bf400dbcbced9552b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6cd8b7001d683051e18c7f47fe02141c7100c22cce7afd8293cb81436ee8ead"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b582517bc5cce20c71c7c82fd4167f7aefa446b7810bafe480e4c0c68deb6f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61295bd8026b2a6f144cdf990543df2107048fe30d10fef4fd4a33b76cdfda8"
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
