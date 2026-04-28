class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "c0b3cc44e3b1df97f7a2ec4859b9ace6f4bcab73c0aeeb4bfe20efae9c40dae8"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "556b03a63ff42ca743c8ec89b6d7a8210b663347a2071c329475bffb975fa613"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "188e50879a11ba8509f9fb0d1936945a7b3c56746801cde2ec6f30beb30f987b"
    sha256 cellar: :any_skip_relocation, ventura:       "945c342b7f6f7c4f18a31131547f27eb1909754a2737a15b5d5b83498e2b34c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777df2be536d5ef3b13d98a08f999ead28ee2b7f94d4eda05021a44843011722"
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
      generate_completions_from_executable(bin/cli, "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
