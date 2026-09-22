class Ncgopher < Formula
  desc "Ncurses gopher and gemini client"
  homepage "https://github.com/jansc/ncgopher"
  url "https://github.com/jansc/ncgopher/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "c91b139fd3ec89dd1c20c75350de1a21624c03b16d086d9e7dd4e5dd8c829761"
  license "BSD-2-Clause"
  head "https://github.com/jansc/ncgopher.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncgopher --version")

    output = shell_output("#{bin}/ncgopher 'not a URL' 2>&1", 101)
    assert_match "Invalid URL: not a URL", output
  end
end
