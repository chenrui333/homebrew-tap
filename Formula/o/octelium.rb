class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "51980bea4d55ef49a01d068d1048c66910efa2d94e4b3ac39ca7d00df50ac587"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d73d6111cf9530c44c976a91ef46b7c434b3298142ab6931dd568cdc21a29e4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d73d6111cf9530c44c976a91ef46b7c434b3298142ab6931dd568cdc21a29e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2241626f01356ec475983be9d98dc0ee0cc76dc292cdab9a8dbf55f19a5cb875"
    sha256 cellar: :any,                 x86_64_linux:  "6d02052ca6cecab6f379349f7c83b84901ddc0af0d31a056e0403ff0a15c2aa3"
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
