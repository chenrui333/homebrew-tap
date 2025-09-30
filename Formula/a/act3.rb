class Act3 < Formula
  desc "Glance at the last 3 runs of your Github Actions"
  homepage "https://tools.dhruvs.space/act3/"
  url "https://github.com/dhth/act3/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5ba04d59ba44e659a0a23eee674923acd92c4bfd622e12bcf8bd993468699fe9"
  license "MIT"
  head "https://github.com/dhth/act3.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "invalid"

    output = shell_output("#{bin}/act3 config gen 2>&1", 1)
    assert_match "Error: no remotes found", output
  end
end
