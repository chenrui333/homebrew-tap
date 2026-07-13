class Karmor < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/kubearmor/kubearmor-client"
  url "https://github.com/kubearmor/kubearmor-client/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "a0491e6ed53e58aaa32214ec644cfc943da4ebc7e4e80373f9ac8782f9020640"
  license "Apache-2.0"
  head "https://github.com/kubearmor/kubearmor-client.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ce229994fc6eb29643e60837583dd727c512f67ba719bd7953d5412192e0e21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd412da63047eeee139906582b4618bcbafd2f77a6d466930fde8cc86f4c905b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1750fdc37c5cd51201e424f50269720190d2d57223e0abd6cabe3d0973d845fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f8bc252daf892ecef0717d596ff8036e02c181457a9cc0f2bd02b8be5f5c39c"
    sha256 cellar: :any,                 x86_64_linux:  "20b51fa77e13b4c061002e09516575fff2f9f2b58eaf33ce3521c185f2203a81"
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
