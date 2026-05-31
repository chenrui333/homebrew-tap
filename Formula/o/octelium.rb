class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "4f0e8c727dd959f8bca3a278d8bef6aafb8debd13d435f2816159e3a262dca5b"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a01279ec600cf8d27595fcc5552aad9fc1b805d7ccde4a26a29149cb6316e97e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a01279ec600cf8d27595fcc5552aad9fc1b805d7ccde4a26a29149cb6316e97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a01279ec600cf8d27595fcc5552aad9fc1b805d7ccde4a26a29149cb6316e97e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eead2f76f38853c9bdbdb8d69f7aea89a7120631afbe033a18e7f19da63aff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "120e4372f27081fe072e3aa134611573be9eb3659356708b226769a80ae3c827"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/octelium/octelium/pkg/utils/ldflags.GitCommit=#{tap.user}
      -X github.com/octelium/octelium/pkg/utils/ldflags.GitTag=#{version}
      -X github.com/octelium/octelium/pkg/utils/ldflags.SemVer=#{version}
      -X github.com/octelium/octelium/pkg/utils/ldflags.GitBranch=main
    ]

    %w[octelium octeliumctl octops].each do |cli|
      system "go", "build", *std_go_args(ldflags:, output: bin/cli), "./client/#{cli}"
      generate_completions_from_executable(bin/cli, shell_parameter_format: :cobra)
    end
  end

  test do
    %w[octelium octeliumctl octops].each do |cli|
      assert_match version.to_s, shell_output("#{bin}/#{cli} version")
    end

    output = shell_output("#{bin}/octelium status 2>&1", 1)
    assert_match "Error: The Cluster domain is not set.", output

    output = shell_output("#{bin}/octops init example.com --bootstrap #{testpath}/bootstrap.yaml 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
