class Ugm < Formula
  desc "TUI to view information about UNIX users and groups"
  homepage "https://github.com/ariasmn/ugm"
  url "https://github.com/ariasmn/ugm/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "96342a6ed3bde5d547edc220405ed81cc45466013d2462cebf25e7145868b731"
  license "MIT"
  head "https://github.com/ariasmn/ugm.git", branch: "main"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("script -qec \"#{bin}/ugm --version\" /dev/null 2>&1")
    assert_match version.to_s, output
  end
end
