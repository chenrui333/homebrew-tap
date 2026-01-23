class Autotag < Formula
  desc "Git repository version tagging tool"
  homepage "https://github.com/autotag-dev/autotag"
  url "https://github.com/autotag-dev/autotag/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "fa694f5e1e8da3229b03b459221764f0de7624aa8119c7f7095fd1820ae72b92"
  license "Apache-2.0"
  head "https://github.com/autotag-dev/autotag.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf50ac8026ac8a1e1b2f0f7d2ef3702e49ff60e4cc8eedf7f21728ce0361a44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caf50ac8026ac8a1e1b2f0f7d2ef3702e49ff60e4cc8eedf7f21728ce0361a44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf50ac8026ac8a1e1b2f0f7d2ef3702e49ff60e4cc8eedf7f21728ce0361a44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "501bfa690ef82144dba38859bdb6ff4981e33965181a833de4b5bfde6c561920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ffeadf0b08c7fd06cebae6d1c072043552fac1fd536a5e1604bcf9019103d43"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./autotag"
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    output = shell_output("#{bin}/autotag version 2>&1", 1)
    assert_match "no stable (non pre-release) version tags found", output
  end
end
