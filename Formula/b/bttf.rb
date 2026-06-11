class Bttf < Formula
  desc "CLI tool for datetime arithmetic, parsing, formatting and more"
  homepage "https://github.com/BurntSushi/bttf"
  url "https://github.com/BurntSushi/bttf/archive/refs/tags/0.1.4.tar.gz"
  sha256 "21b265959403c02406137adac1012f676a25ad67d6fbf29a553b9e459c7bbc73"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/bttf.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bttf --version 2>&1", 1)
    assert_equal "2026-06-11\n", shell_output("#{bin}/bttf time fmt -f '%F' 2026-06-11")
  end
end
