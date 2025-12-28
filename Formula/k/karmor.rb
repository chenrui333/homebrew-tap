class Karmor < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/kubearmor/kubearmor-client"
  url "https://github.com/kubearmor/kubearmor-client/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "364816b662e08fa971f510722aa5f90ea97fb03cef001928f2d3be9dcc41f272"
  license "Apache-2.0"
  head "https://github.com/kubearmor/kubearmor-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe7587835673493d6f9ff5a8c01b12b992bfd293d94b07922cde7df2d3d8c43d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "318685091a580da8832eccdebca24e88fa3b0478b18ec96e81c9af0eefe40bd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c81ce17eb38d8aaa34c2dcdf6ff68fdbaf156443fbf6994650b78e9567ee543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caff006684e1afee57a9cf3719c661bc923882f55d78bd73e143269ee999c2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9af6ac0e3fa6ff2f3fd34168eda4b0ef4cdb682bfc2fb5aa35a98dd4d1f19fe"
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
