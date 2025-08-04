class Seastar < Formula
  desc "MCP server for Swagger/OpenAPI endpoints"
  homepage "https://github.com/nonscalar/Seastar"
  url "https://github.com/nonscalar/Seastar/archive/refs/tags/v0.1.0-alpha.1.tar.gz"
  sha256 "15973e69b828236deddeae7be853ae9aefd9311480ae6dee1ef351d54c1af3c1"
  license "GPL-3.0-or-later"
  head "https://github.com/nonscalar/Seastar.git", branch: "main"

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
