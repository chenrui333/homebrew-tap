class Grmon < Formula
  desc "Command-line monitoring for goroutines"
  homepage "https://github.com/bcicen/grmon"
  url "https://github.com/bcicen/grmon/archive/refs/tags/v0.1.tar.gz"
  sha256 "5a01e42a168e822e96ab08848a8c6b2db990ed41d5581fd98759b6fd98dfc364"
  license "MIT"
  head "https://github.com/bcicen/grmon.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02bf92a0760bfbbce688798bdf453fb0f87c0d7f47acaf54beb853a0f470b39d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0f16539d66dcc0b2312f3ed4ec48c79cbd0928c005045986a80e866186a67a"
    sha256 cellar: :any_skip_relocation, ventura:       "6b25c35b56820782cb2289c29619d52975270bc6ed3388c579a09a4acc08f1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4906e7e06b260cea0061a56f84f54477b70f5cb726fe3dfd9a5fa784ab8c3a8d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end
end
