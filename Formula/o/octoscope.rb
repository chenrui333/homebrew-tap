class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "cd3f24d1a22674f31bb98eaa104fcdf2ba769585bc5efdeae55827c38c8f517f"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
