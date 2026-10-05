class Karmor < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/kubearmor/kubearmor-client"
  url "https://github.com/kubearmor/kubearmor-client/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "a0491e6ed53e58aaa32214ec644cfc943da4ebc7e4e80373f9ac8782f9020640"
  license "Apache-2.0"
  head "https://github.com/kubearmor/kubearmor-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60845f5731cad8742ac00f2ab8e4816982697a4cdcfda1176f4f8ad992cb2b93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e1b158b066c9a83fb8ee8308cb10041eba3591f34c38c1d14997cbe6cfffa58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db9d8afbca2b7315dd3e32979f0d14740eb92ff53dd5c99f12b2056c069b43b3"
    sha256 cellar: :any,                 x86_64_linux:  "b2d5f7bd71a1555fc461441f7cf881017461668e2514e577d1485de4ba44a175"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubearmor/kubearmor-client/selfupdate.GitSummary=#{version}
      -X github.com/kubearmor/kubearmor-client/selfupdate.BuildDate=#{time.iso8601}
    ]
    # TODO: Remove http2legacy tag when upstream bumps golang.org/x/net to >= v0.55.0 for Go 1.27
    # ref: https://github.com/grpc/grpc-go/issues/9206
    system "go", "build", *std_go_args(ldflags:, tags: "http2legacy")

    generate_completions_from_executable(bin/"karmor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/karmor version")

    expected = if OS.mac?
      "unsupported environment or cluster not configured correctly"
    else
      "Didn't find KubeArmor in systemd or Kubernetes"
    end

    exit_status = OS.mac? ? 1 : 0
    assert_match expected, shell_output("#{bin}/karmor probe 2>&1", exit_status)
  end
end
