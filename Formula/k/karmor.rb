class Karmor < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/kubearmor/kubearmor-client"
  url "https://github.com/kubearmor/kubearmor-client/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "4f032e427c6bfc1bac70da2b856ddbabab107d071231653d245293a540524ca1"
  license "Apache-2.0"
  head "https://github.com/kubearmor/kubearmor-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec070ab9778cdb7dfaa3a7466d6037268509053015840aa579ad73d34d1623c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4e66c497b3653fccb8022cc0275909f8dda747a2ad7f7a1310753ec89f86056"
    sha256 cellar: :any_skip_relocation, ventura:       "d013d6733d24943988a803c628f7123e5a0bc2717e9b426efd710ef0d0e1957b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acde295f99275e2064df2d511427f7ddbe2e513a635fa5f71b630e8676b24f0e"
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
