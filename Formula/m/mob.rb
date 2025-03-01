class Mob < Formula
  desc "Tool for smooth git handover"
  homepage "https://mob.sh/"
  url "https://github.com/remotemobprogramming/mob/archive/refs/tags/v5.3.3.tar.gz"
  sha256 "e42748db781862a00f343c408860d42244e1709d1fb611a7b5c3e3630ec60dc0"
  license "MIT"
  head "https://github.com/remotemobprogramming/mob.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a9e39ca556a8da839f2c3defcff18a041de393ac6f186d5496ed57c91b75af6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79556880a037031a1b7f6a62a0f6a0ab7a219d6a3c08c2379b303334450ea154"
    sha256 cellar: :any_skip_relocation, ventura:       "237b756e1a39001ee70f9aab2c0dea3b3fe168a1acc7f6192af6a65927502b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "556c8ed753ebb5543adbf5c99417e6b7d9101e89945bedf8c7308d9b10649f75"
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
