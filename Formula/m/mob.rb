class Mob < Formula
  desc "Tool for smooth git handover"
  homepage "https://mob.sh/"
  url "https://github.com/remotemobprogramming/mob/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "9082fa79688a875a386f9266e4f09efaeff5d14ad1288a710f6fb730974f3040"
  license "MIT"
  head "https://github.com/remotemobprogramming/mob.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e05d3933d9e2c7567eeb4dd4c3b5b45473830f237820b6f969c64dd1ed32fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4777ab7742df2654f110211bec1cfea24375dd49e8a57e3eb6d2db8e1b91cdd1"
    sha256 cellar: :any_skip_relocation, ventura:       "6d3baba9caa89273bff22737d49594b957d7d681e35a60b1e573d427e296ee2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26103682b266809810722150f8b8431a21766fdada3c316563d1f7645e011f9f"
  end

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
