class Netfetch < Formula
  desc "K8s tool to scan clusters for network policies and unprotected workloads"
  homepage "https://github.com/deggja/netfetch"
  url "https://github.com/deggja/netfetch/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "6029d93da6633a626d6920944825c76b5552e4ad5175101f661281e30b36b1cf"
  license "MIT"
  head "https://github.com/deggja/netfetch.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/deggja/netfetch/backend/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./backend"

    generate_completions_from_executable(bin/"netfetch", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netfetch version")

    assert_match ".kube/config: no such file or directory", shell_output("#{bin}/netfetch scan")
  end
end
