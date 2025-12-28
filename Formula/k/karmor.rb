class Karmor < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/kubearmor/kubearmor-client"
  url "https://github.com/kubearmor/kubearmor-client/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "364816b662e08fa971f510722aa5f90ea97fb03cef001928f2d3be9dcc41f272"
  license "Apache-2.0"
  head "https://github.com/kubearmor/kubearmor-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55cd3ee3e1b6eb27dab4ebbbf64e611a8c7184bf3707831d51de1dacef0fe5b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b329f3f092f6bb624cabe9f9e1d961782a0d2aa316da703f0f0aaf9bac49ddbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328c505610ed4c4ac7d6a6408fbe036f5fcad0e6d16d7d9366183b2f26755613"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2d39fe3209526d845ee24942c75ffc1fd2a92bcd8672cb4c1e571d65b49554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1b35ffeff3b0c9222ac1b258c5795c784ee1c01e3ecb912670dfc558264b79"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubearmor/kubearmor-client/selfupdate.GitSummary=#{version}
      -X github.com/kubearmor/kubearmor-client/selfupdate.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
