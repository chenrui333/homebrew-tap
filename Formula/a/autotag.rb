class Autotag < Formula
  desc "Git repository version tagging tool"
  homepage "https://github.com/autotag-dev/autotag"
  url "https://github.com/autotag-dev/autotag/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "71d6f082efa5c641461f603c16b50c1d3e4aae2cdd5f550b912efb5051043a99"
  license "Apache-2.0"
  head "https://github.com/autotag-dev/autotag.git", branch: "main"

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
