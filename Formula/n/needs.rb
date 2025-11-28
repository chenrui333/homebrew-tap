class Needs < Formula
  desc "Checks if bin(s) are installed, oh and the version too"
  homepage "https://github.com/NQMVD/needs"
  url "https://github.com/NQMVD/needs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8ae733e7dd37a5d23b934c1a8c1eebcc9e9296e790944d7d5dc82e45f5b0279e"
  license "GPL-3.0-or-later"
  head "https://github.com/NQMVD/needs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needs --version")

    assert_match "curl", shell_output("#{bin}/needs curl")
    assert_match "go not found", shell_output("#{bin}/needs go")
  end
end
