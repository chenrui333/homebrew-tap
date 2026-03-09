class Envfetch < Formula
  desc "Lightweight cross-platform CLI tool for working with environment variables"
  homepage "https://github.com/ankddev/envfetch"
  url "https://github.com/ankddev/envfetch/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "f98e8bac25069830383a594bb7ab3f85b262ef04191e11384791a475aa70f85e"
  license "MIT"
  head "https://github.com/ankddev/envfetch.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envfetch --version")

    output = shell_output("#{bin}/envfetch set TEST_ENVFETCH_VAR brewtest -- env")
    assert_match "TEST_ENVFETCH_VAR=brewtest", output
  end
end
