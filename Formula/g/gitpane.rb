class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "e5383b731a0d8b7fbfee6682889d543807701672de47c06b9107e9c7383b3fce"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f0396a746795f079045b4b5ea4e3b061acc64f1c21e7cd7cc1097d335c91361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395dfee76f9acb4986268ce1dec6b834e365fca52de1161ec96f8a032d752b6b"
    sha256 cellar: :any,                 arm64_linux:   "fcc579dab03bc47faf824e6b33be7c0d208312016fe1b6e4d9f6688dca304d8e"
    sha256 cellar: :any,                 x86_64_linux:  "469bd1374c3b216c953c4a2faa23d363d9e2343c591e9f6b2e31d7d226c96747"
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
