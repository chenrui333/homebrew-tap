class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "40addbfac6c38e923df03d622b6d150d51fc254c4a622b4edd34658213cad36d"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29eb8306c49ec2fb7a988d19556ff6a46a3f3dbd7ea50c4dd243d0d71226023a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fed3044f57b1cb7efb2844e64ba90fedd90858c69f64711243611b83cfe5e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7635ce344817861e9e7234c58ad9eb401b8f5e3229641b36c075dd479cda8cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26d628633d3a5ee8a6691ef2aa2d7be9abde8bbbe534fc8fe558a9839d221d2e"
    sha256 cellar: :any,                 x86_64_linux:  "2ef2cf05846edf1bcd752795567fa1adf41016730cd4e95672d96692e3f82fd0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/omnictl --version")
    system bin/"omnictl", "--version"

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
