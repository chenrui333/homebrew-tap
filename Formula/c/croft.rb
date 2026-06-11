class Croft < Formula
  desc "VSCode-style TUI text editor"
  homepage "https://codeberg.org/vitali87/croft"
  url "https://codeberg.org/vitali87/croft/archive/8b6e7e0e26cded417b386a4f0cd2e1a5fb9674e0.tar.gz"
  version "0.1.347"
  sha256 "32dd8364251158856dde56ae96925c53c8a936a00e518088187ab10d7fb12b61"
  license "MIT"
  head "https://codeberg.org/vitali87/croft.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/croft --version")
    assert_match "Terminal-based VS Code replica", shell_output("#{bin}/croft --help")
  end
end
