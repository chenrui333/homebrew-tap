class Netfetch < Formula
  desc "K8s tool to scan clusters for network policies and unprotected workloads"
  homepage "https://github.com/deggja/netfetch"
  url "https://github.com/deggja/netfetch/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "6029d93da6633a626d6920944825c76b5552e4ad5175101f661281e30b36b1cf"
  license "MIT"
  head "https://github.com/deggja/netfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f4bed5e625834553d378dee1446013e570aeff8faac8d8d170a23392acdc5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90d2ea13a8137aa64adc121f8c263476c6e81ea4bb8e32031cf96ba2dd496264"
    sha256 cellar: :any_skip_relocation, ventura:       "8640d3fc847a13d9dece85a6f1e4dab2a54bac7adb8f4b784a5ce7aaaf4d7b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150f0d1ca86b81724a67f0db50bb121efa9c389399a19799179efc5d3c696465"
  end

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
