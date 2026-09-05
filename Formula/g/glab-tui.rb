class GlabTui < Formula
  desc "Terminal interface for GitLab and GitHub"
  homepage "https://github.com/rcieri/glab-tui"
  url "https://github.com/rcieri/glab-tui/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "ec80641f6ed8429e079c727b861a72709a2bf542fc82946c3e59032799c8c3bb"
  license "MIT"
  head "https://github.com/rcieri/glab-tui.git", branch: "main"

  depends_on "rust" => :build
  depends_on "gh"
  depends_on "glab"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glab-tui --version")
    output = shell_output("#{bin}/glab-tui repos")
    assert_match "Recent repositories:", output
    assert_match "(none)", output
  end
end
