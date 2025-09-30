class Act3 < Formula
  desc "Glance at the last 3 runs of your Github Actions"
  homepage "https://tools.dhruvs.space/act3/"
  url "https://github.com/dhth/act3/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5ba04d59ba44e659a0a23eee674923acd92c4bfd622e12bcf8bd993468699fe9"
  license "MIT"
  head "https://github.com/dhth/act3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d53f198646c334c2e7889a96630cc10508c4bb0687dcb832c0c370364eb40f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "143a75a8c59dc6dec4e432a70261846e63fcada458be1dcb6d0227d534f76d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d8697371c9e79164894cef40d604cbc9d45deeeb8ed7c39ad9ccd31aa8c2901"
  end

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
