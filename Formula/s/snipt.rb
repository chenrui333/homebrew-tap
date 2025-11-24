class Snipt < Formula
  desc "Powerful text snippet expansion tool"
  homepage "https://github.com/snipt/snipt"
  url "https://github.com/snipt/snipt/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a83d47c564e69c5805d4d99c3daa09ddee342d19c6df69f40e0fb6deb8647ade"
  license "MIT"
  head "https://github.com/snipt/snipt.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/snipt-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snipt --version")
    assert_match "snipt daemon is not running", shell_output("#{bin}/snipt status")
    assert_match "Database not found", shell_output("#{bin}/snipt list 2>&1", 1)
  end
end
