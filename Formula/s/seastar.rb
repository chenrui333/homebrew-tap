class Seastar < Formula
  desc "MCP server for Swagger/OpenAPI endpoints"
  homepage "https://github.com/nonscalar/Seastar"
  url "https://github.com/nonscalar/Seastar/archive/refs/tags/v0.1.0-alpha.1.tar.gz"
  sha256 "15973e69b828236deddeae7be853ae9aefd9311480ae6dee1ef351d54c1af3c1"
  license "GPL-3.0-or-later"
  head "https://github.com/nonscalar/Seastar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b281d9ded7be77e1653d2d9a4faa1d5d2edbc647c545c14babe4edb68ed3f8c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51672d085b1351eeaa4784da71a8d73dd2e40dbb144dfd26484b0296401486d2"
    sha256 cellar: :any,                 arm64_linux:   "4ad346b56560ac5786f8e379ddd70c5e5140420d759e90b58aa4b47da0c410e0"
    sha256 cellar: :any,                 x86_64_linux:  "0c26f69e6263fb52fce41641aa4627e2c2ffbd9ae8f5b12540fa4034b68ff05b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

  # `seastar new` clones templates into ~/.seastar/templates at runtime; stage a pinned copy instead.
  resource "seastar-templates", :test do
    url "https://github.com/AI314159/seastar-templates/archive/d2294c864ba7d9ce63ed78c3b97ae010304fc508.tar.gz"
    sha256 "e49af3c8d3de1a47ac3026f036446e33f4a9adbe361080366a4dcf5b86cf2c73"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/".seastar/templates").install resource("seastar-templates")

    output = shell_output("#{bin}/seastar new --language c test_project 2>&1")
    assert_match "Initialized binary package 'test_project'", output
  end
end
