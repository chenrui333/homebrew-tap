class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "a4216c3fd803f23e804753e0609a33154e311f8601b0131bfdc1f392a285c77a"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a73b3c0a249d9993ad4439fe4be71d0a9a626eb13181eaf66732d50a119f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea4204b4dbcd336e1186e18664d00e192d37c8937069a9d7435bbf1ab8375b6d"
    sha256 cellar: :any,                 arm64_linux:   "b98217f836e828db482191350b35d68ccf0c5ec5e0e619be20c8e1377c856d95"
    sha256 cellar: :any,                 x86_64_linux:  "f3461bac0bb4b69d118b4025b66ccfe1d24af1b1773b1f15be47cd543731aa76"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gitpane", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
