class Mob < Formula
  desc "Tool for smooth git handover"
  homepage "https://mob.sh/"
  url "https://github.com/remotemobprogramming/mob/archive/refs/tags/v5.3.3.tar.gz"
  sha256 "e42748db781862a00f343c408860d42244e1709d1fb611a7b5c3e3630ec60dc0"
  license "MIT"
  head "https://github.com/remotemobprogramming/mob.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mob --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "test"
    assert_match "you are on base branch 'main'", shell_output("#{bin}/mob status")
    output = shell_output("#{bin}/mob config")
    assert_match "MOB_CLI_NAME=\"mob\"", output
  end
end
