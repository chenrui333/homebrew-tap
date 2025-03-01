class Grmon < Formula
  desc "Command-line monitoring for goroutines"
  homepage "https://github.com/bcicen/grmon"
  url "https://github.com/bcicen/grmon/archive/refs/tags/v0.1.tar.gz"
  sha256 "5a01e42a168e822e96ab08848a8c6b2db990ed41d5581fd98759b6fd98dfc364"
  license "MIT"
  head "https://github.com/bcicen/grmon.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end
end
