class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "0d9d57913d09f7eb0a1f69b025195cc51572a9d70e019ff41277f8bf7c46ca49"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "dbab770920cc4da8435410014fcf3e6b6441e46fe6070779be95efb7c55a762d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "419eb3dd1021ac040e92b316ef54d27f18c47d8d5e5c3b31f604cde5a937bcf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95ad514678147875ff74c2e53b9c118ed88668b20fdbf56e1d0b33e22ea3454"
    sha256 cellar: :any,                 arm64_linux:   "8ca10e42d55c9edc436ee317f48cf6dd8c3a4357f35d931d77789c5f10d0aed2"
    sha256 cellar: :any,                 x86_64_linux:  "87685d0075d7c420c9a1abc9ef9702a596d986bd82bf4d1d5203cbc55ceb20db"
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
