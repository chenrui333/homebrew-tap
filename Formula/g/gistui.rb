class Gistui < Formula
  desc "Terminal interface for GitHub Gists"
  homepage "https://github.com/akunzai/gistui"
  url "https://github.com/akunzai/gistui/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "6a90c9a1e3ba3fba8e8c1f642ca7d33f37f74e67674b1a5347db9c5eb6811408"
  license "MIT"
  head "https://github.com/akunzai/gistui.git", branch: "main"

  depends_on "rust" => :build
  depends_on "gh"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gistui --version")
    output = shell_output("#{bin}/gistui #{testpath}/missing 2>&1", 1)
    assert_match "path does not exist", output
  end
end
