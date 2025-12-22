class Ergo < Formula
  desc "Modern IRC server (daemon/ircd) written in Go"
  homepage "https://github.com/ergochat/ergo"
  url "https://github.com/ergochat/ergo/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "bfda2be82aa133ddd7a03c2121d6807c8a1b9f5c055f0bbb90451baa2a249ce4"
  license "MIT"
  head "https://github.com/ergochat/ergo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54885942c99fa820d1c6ca046172e6ed1cb0c849249e4b2d4469ad7ec7cce977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54885942c99fa820d1c6ca046172e6ed1cb0c849249e4b2d4469ad7ec7cce977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54885942c99fa820d1c6ca046172e6ed1cb0c849249e4b2d4469ad7ec7cce977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640522f2470539e7a5cfe7e78d5a015304fb966a2ac35d038742a0bd247c7d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9be548cf069eb2ec3d52208c1b07fa614577852b6900e2f83efeed1fe0ac573"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ergo --version")

    output = shell_output("#{bin}/ergo defaultconfig")
    assert_match "# This is the default config file for Ergo", output
  end
end
