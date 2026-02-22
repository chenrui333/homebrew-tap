class Firm < Formula
  desc "Text-based work management system for technologists"
  homepage "https://firm.42futures.com/"
  url "https://github.com/42futures/firm/archive/refs/tags/0.5.0.tar.gz"
  sha256 "f98c0f436be249f9b52e180c9015c1b4635e93447f64cb0b592776e4e7f93c34"
  license "AGPL-3.0-only"
  head "https://github.com/42futures/firm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "078978dd8ee81154962e14357adbf91a5643986084eba5d4b3152c75f6a3f8cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc877568f60fc73b5e23c49a76080fb891fa3c4009811fdd037df9c8e659bf59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c90d9f6e0cdb91a5eec5bf65a67f7536929d8f2cb1d6a68dcc0942d021ba623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c790cb88343ca5a01584b55405ef301235dba056646dba185adbb6db869bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e583563a1df25ef5c1bcd6f5cba7be318b17ed4e77b406fd1244a2e2737d9ee"
  end

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
