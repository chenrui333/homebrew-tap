class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "098f261cfc980710876b6f09e6ab501696514f0a39b86b6d28e052cde4ae5b07"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eabcc27fd9f742caf7cd64af0f5e9ad03c4dbdbcaa195a955f7316bef9f31cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eabcc27fd9f742caf7cd64af0f5e9ad03c4dbdbcaa195a955f7316bef9f31cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eabcc27fd9f742caf7cd64af0f5e9ad03c4dbdbcaa195a955f7316bef9f31cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bdc11bab124a1f591e59979309d5c81f560077a41703e81316dc3eae5588df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3d8f552367a8ad39d947b92db53257e07dafe26cb8aeb7c53976cc96e7e7a2"
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
