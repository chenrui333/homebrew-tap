class Shuk < Formula
  desc "Filesharing command-line application that uses Amazon S3"
  homepage "https://github.com/darko-mesaros/shuk"
  url "https://github.com/darko-mesaros/shuk/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "74b5d7af63e256cf8c9496a8739bf6ee67a133a760cb676ed4128897ac85593c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/darko-mesaros/shuk.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuk --version")

    output = shell_output("#{bin}/shuk test_file 2>&1", 1)
    assert_match "Could not read config file", output
  end
end
