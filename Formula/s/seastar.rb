class Seastar < Formula
  desc "MCP server for Swagger/OpenAPI endpoints"
  homepage "https://github.com/nonscalar/Seastar"
  url "https://github.com/nonscalar/Seastar/archive/refs/tags/v0.1.0-alpha.1.tar.gz"
  sha256 "15973e69b828236deddeae7be853ae9aefd9311480ae6dee1ef351d54c1af3c1"
  license "GPL-3.0-or-later"
  head "https://github.com/nonscalar/Seastar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "38e7441a8e803f03fc8f6777b288ec3340a584f3cec5967c45b0d0b3b9443c52"
    sha256 cellar: :any,                 arm64_sonoma:  "ec7b693ba0c7d583797a28557719a123f6c24358581c2b6dce947c85ecf57745"
    sha256 cellar: :any,                 ventura:       "f378e209055cd7ddc37770204a6ebf35d8f3bad4dff441d53cbac5fc732d3a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45708f62c13c30114dc8f5db9a15a692a935f5251ba593604ff973a45e731d63"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/seastar new --language c test_project 2>&1")
    assert_match "Initialized binary package 'test_project'", output
  end
end
