class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "b47d01615666b2b76ec4035c42cf424f9925a751b1a4be0e508c21fd8ae4838c"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7d40afbe88dd227b32b5354011f63d94f3eccecedc9c6ba4937e1eed6b011a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7d40afbe88dd227b32b5354011f63d94f3eccecedc9c6ba4937e1eed6b011a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b18fe85fe3c1a4f824d40b309bc371162cb374620cb8f5152ab8f70cc0a9c43a"
    sha256 cellar: :any,                 x86_64_linux:  "0992fe5e19a0b91644c9198006660e4b2328747a621f78831514c1d25b7821ca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
    assert_match "Please set the kubeconfig file path", output
  end
end
