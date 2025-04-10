class Firectl < Formula
  desc "CLI to run Firecracker microVMs"
  homepage "https://github.com/firecracker-microvm/firectl"
  url "https://github.com/firecracker-microvm/firectl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4d3d2f2b404e9e0bbeb3a1816c56db69b5d93c85523b135fc39c38566afd0233"
  license "Apache-2.0"
  head "https://github.com/firecracker-microvm/firectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "97d9556d3588d7fb409ea1131116517b73dc9540e1a426bbeda7e7257b0c231f"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/firectl version 2>&1", 1)
    assert_match '\"firecracker\": executable file not found', output
  end
end
