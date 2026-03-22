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
    output = pipe_output("script -q -c '#{bin}/ugm' /dev/null", "q", 0)
    assert_match(/\d+ items/, output)
  end
end
