class Karmor < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/kubearmor/kubearmor-client"
  url "https://github.com/kubearmor/kubearmor-client/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "4f032e427c6bfc1bac70da2b856ddbabab107d071231653d245293a540524ca1"
  license "Apache-2.0"
  head "https://github.com/kubearmor/kubearmor-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3470891d6e2f4595e6b1a0cf5ec19c2f089bad800bfaa288cd53af458a447d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26de297dd8a5e0aeb3e3cd22cf5cefde37b8270b91ac1912bd948083a2c69547"
    sha256 cellar: :any_skip_relocation, ventura:       "15a74be344ee241a6775090facd9ca0f11d1d5fbb250208ff1c807aa6ea9aca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b011aeecbf36154f0a9431ef84729fb5aed9464e7311998e6fb54f89fb21622"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubearmor/kubearmor-client/selfupdate.GitSummary=#{version}
      -X github.com/kubearmor/kubearmor-client/selfupdate.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"karmor", "completion")
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
