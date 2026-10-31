class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "a4216c3fd803f23e804753e0609a33154e311f8601b0131bfdc1f392a285c77a"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "334a764a7c8b17fc2f0adee1a9731bb636c1ccbf0b0637900e284283f6014a09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "787c7f4bc30eb953896e1e9e113dab84c789936c0fd83ad10d7f40aecb538465"
    sha256 cellar: :any,                 arm64_linux:   "acdc9dbc2fd66f67c2321dc9c020a19056adfcb9f10745f364d1cf0a614b82cf"
    sha256 cellar: :any,                 x86_64_linux:  "9851ab11c673904b505cbd0b596826d06503da5b4dfd93aa4cd9e1529b3fb5c2"
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
