class Autotag < Formula
  desc "Git repository version tagging tool"
  homepage "https://github.com/autotag-dev/autotag"
  url "https://github.com/autotag-dev/autotag/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "71d6f082efa5c641461f603c16b50c1d3e4aae2cdd5f550b912efb5051043a99"
  license "Apache-2.0"
  head "https://github.com/autotag-dev/autotag.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04fb1ccea2013872d08894e09183f34160dcb77716c37af6e1cface0a1830606"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d72e9b909813c35083a8564d1742f933bc03d68ff1e36133eb8e48e53beaab"
    sha256 cellar: :any_skip_relocation, ventura:       "c5eaa8725e62dc33d04befb9551cec8fd42dc6b8e3b612c5a98f448689b0d42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa65652baea635086743b0a0e0d7a33f4565ccb5705cf51ae42025736c90bea"
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
