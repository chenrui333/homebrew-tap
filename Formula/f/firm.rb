class Firm < Formula
  desc "Text-based work management system for technologists"
  homepage "https://firm.42futures.com/"
  url "https://github.com/42futures/firm/archive/refs/tags/0.5.0.tar.gz"
  sha256 "f98c0f436be249f9b52e180c9015c1b4635e93447f64cb0b592776e4e7f93c34"
  license "AGPL-3.0-only"
  head "https://github.com/42futures/firm.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  resource "tree-sitter-firm" do
    url "https://github.com/42futures/tree-sitter-firm/archive/0b4637918f0380224530aa4d8d7974fc5d7d3530.tar.gz"
    sha256 "0a3831758e6694c6c7f0e343b5b75a952e431f52ce457254770dfc99cb5402e9"
  end

  def install
    resource("tree-sitter-firm").stage buildpath/"tree-sitter-firm"

    system "cargo", "install", *std_cargo_args(path: "firm_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firm --version")

    output = shell_output("#{bin}/firm unknown 2>&1", 2)
    assert_match "unrecognized subcommand", output
  end
end
