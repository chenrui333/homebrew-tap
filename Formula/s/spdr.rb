class Spdr < Formula
  desc "Read-only DDR5 SPD decoder and semantic linter in Rust"
  homepage "https://github.com/The-Open-Memory-Initiative-OMI/spdr"
  url "https://github.com/The-Open-Memory-Initiative-OMI/spdr/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f0bf7a9d80b11885ce47e7288cde33df712a22ae0d1c393cda6c4ee0a308c5f7"
  license "Apache-2.0"
  head "https://github.com/The-Open-Memory-Initiative-OMI/spdr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "spdr-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spdr --version")
    assert_match "decode", shell_output("#{bin}/spdr --help")
  end
end
