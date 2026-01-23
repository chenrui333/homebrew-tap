class Autotag < Formula
  desc "Git repository version tagging tool"
  homepage "https://github.com/autotag-dev/autotag"
  url "https://github.com/autotag-dev/autotag/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "fa694f5e1e8da3229b03b459221764f0de7624aa8119c7f7095fd1820ae72b92"
  license "Apache-2.0"
  head "https://github.com/autotag-dev/autotag.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d36b97c3d26d31877de330b2a82c45fc554b997ab07d8f455714cc5c02519e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d36b97c3d26d31877de330b2a82c45fc554b997ab07d8f455714cc5c02519e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d36b97c3d26d31877de330b2a82c45fc554b997ab07d8f455714cc5c02519e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e2030acbac198380a6d93bbbf2929c1172c29c746839521f7d60ccbaea5b356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12fa01eecb282d8ae048c9f55181bec3d080ee98854221db6aea1b01c8efa16"
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
