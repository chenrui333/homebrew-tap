class Gmap < Formula
  desc "CLI for visualizing Git activity"
  homepage "https://github.com/seeyebe/gmap"
  url "https://github.com/seeyebe/gmap/archive/refs/tags/0.3.3.tar.gz"
  sha256 "a53ef4474409df65bbe600b2c239776e498a06a956143c7d7f2fcef03dd32f2e"
  license "MIT"
  head "https://github.com/seeyebe/gmap.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gmap --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"
    assert_match "Commit Activity Heatmap", shell_output("#{bin}/gmap heat")
  end
end
