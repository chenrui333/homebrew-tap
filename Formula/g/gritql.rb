class Gritql < Formula
  desc "Query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  url "https://github.com/getgrit/gritql.git",
      tag:      "v0.1.0-alpha.1743007075",
      revision: "fe3643396dab7b5cfa62ccd76d23cb0f03cf93e0"
  license "MIT"
  head "https://github.com/getgrit/gritql.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli_bin")
  end

  test do
    system bin/"grit", "--version"
    system bin/"grit", "list"
  end
end
