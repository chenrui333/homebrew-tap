class Keyhunter < Formula
  desc "Find leaked API keys in websites"
  homepage "https://github.com/DonIsaac/keyhunter"
  url "https://github.com/DonIsaac/keyhunter/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "dc377e67f3593e710f17159f3fcfd2c6f60591cd908a294f9ea7f3a50a9f42fa"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "build-binary,report", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keyhunter --version")

    output = shell_output("#{bin}/keyhunter https://example.com")
    assert_match "Found \e[33m0\e[39m keys across \e[33m0\e[39m scripts and \e[33m2\e[39m pages", output
  end
end
