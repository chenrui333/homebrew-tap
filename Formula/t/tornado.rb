class Tornado < Formula
  desc "SQLite explorer with Vim key bindings"
  homepage "https://codeberg.org/ozeye/tornado"
  url "https://codeberg.org/ozeye/tornado/archive/v0.5.0.tar.gz"
  sha256 "9f7741f41e439bca5065ff044b188390e4039e81e55e0ace13798baff10aac27"
  license "MIT"
  head "https://codeberg.org/ozeye/tornado.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d08732acb3fee0e823c1626319c78625ef202a8494bc477a5e919cbdc7d9dfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d08732acb3fee0e823c1626319c78625ef202a8494bc477a5e919cbdc7d9dfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4418a75f8e8d4872b15b80785379f9d10eff04d3c575ad6f2606e1a6fa2df1a"
    sha256 cellar: :any,                 x86_64_linux:  "c2660165074fb9141c888ad2c4d670f2c28e44ebc0cdc5f8d670ed0d22e061a3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tornado"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tornado --version")
    assert_match "flag provided but not defined", shell_output("#{bin}/tornado --invalid-option 2>&1", 2)
  end
end
