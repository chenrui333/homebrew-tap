class Autotag < Formula
  desc "Git repository version tagging tool"
  homepage "https://github.com/autotag-dev/autotag"
  url "https://github.com/autotag-dev/autotag/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "71d6f082efa5c641461f603c16b50c1d3e4aae2cdd5f550b912efb5051043a99"
  license "Apache-2.0"
  revision 1
  head "https://github.com/autotag-dev/autotag.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86c9d2513479c264a1f15533b09943db64245b816d0ef640b67c675c4be38cd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c9d2513479c264a1f15533b09943db64245b816d0ef640b67c675c4be38cd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c9d2513479c264a1f15533b09943db64245b816d0ef640b67c675c4be38cd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247166c6babbf55c54093affdf3b29d4e4bb5f3a00493107b320c2e60cc69f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "332fe10bfe616a61f01fc7a3609d6815f11975c6a9efbb815c86426e9b6f30ac"
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
