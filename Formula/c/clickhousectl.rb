class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "62fbaf4e1fa59174cbfd0ce90fcb700d3f607283646f9e6742ed189ac4d273a5"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clickhousectl --version")

    output = shell_output("#{bin}/clickhousectl cloud auth status")
    assert_match "Not configured", output
  end
end
