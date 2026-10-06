class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "2950bee74be546c3037a00f10d3b7c992fc62e2a904ce2c645eee4c51c221f82"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a814cb0e9b9d447855a339ba82de7081a9c15b17e2c779e6d52ab2d02df2bcca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a814cb0e9b9d447855a339ba82de7081a9c15b17e2c779e6d52ab2d02df2bcca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61211db5cff0c1f34089919d369868bc57c7a9ca77dc0f55f394c664665ae378"
    sha256 cellar: :any,                 x86_64_linux:  "36510813b6d61eaa59c98bc4024ce7cea257ccc3d2b205381235425cfdca20c1"
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
