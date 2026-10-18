class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "316d9080be06991bc94497ab240a75bb8f7b80932bc341bda59c497b7c618aab"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "825e3c387e0c88d8d9044524f60e9fd98ec8520c647a4fe3e0c407224be7b3ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "825e3c387e0c88d8d9044524f60e9fd98ec8520c647a4fe3e0c407224be7b3ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fabd84abc76ad86bb8bf093d38fccf87e1c5b61a9cae5d7de708d4b3c476378"
    sha256 cellar: :any,                 x86_64_linux:  "c8824a5794bf31b2f128b53a76e3c3d1823c09e23bf74f49d00f98d89e7513c7"
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
