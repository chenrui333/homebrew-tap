class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "4f0e8c727dd959f8bca3a278d8bef6aafb8debd13d435f2816159e3a262dca5b"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d7080cb4eef08c1c1f0631305dbc651953171d59d13d240135ea516f11c5cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48d7080cb4eef08c1c1f0631305dbc651953171d59d13d240135ea516f11c5cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d7080cb4eef08c1c1f0631305dbc651953171d59d13d240135ea516f11c5cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "075ac7cd77e5412ea4eddf7137dafd7d036fe82b62b16ce47396bd5534fbf7a8"
    sha256 cellar: :any,                 x86_64_linux:  "b63c800bc1db41a303d10f5c9678f42b9dd8fa81e1b46a79c0a9eaa1ff2254f1"
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
