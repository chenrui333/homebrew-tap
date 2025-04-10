class Firectl < Formula
  desc "CLI for jenkins"
  homepage "https://github.com/firecracker-microvm/firectl"
  url "https://github.com/firecracker-microvm/firectl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4d3d2f2b404e9e0bbeb3a1816c56db69b5d93c85523b135fc39c38566afd0233"
  license "Apache-2.0"
  head "https://github.com/firecracker-microvm/firectl.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firectl version")
  end
end
