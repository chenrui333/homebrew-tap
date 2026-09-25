class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "7fd84a0756ca255f7e2bb055fa1fa549b2284cce55ad67b56c5ebc293514d140"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0e69d39002411f763e0bd7b9628d9e2306ed378905ac9503e648dadbb6269e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0e69d39002411f763e0bd7b9628d9e2306ed378905ac9503e648dadbb6269e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48f01d445acb9a13747d18d5770c67e659944bd585c2780a7d9ebee6b6be594d"
    sha256 cellar: :any,                 x86_64_linux:  "ec013c70199637136ef22541eb361aa17946a51ef8d18ed2be9ab1cf54895230"
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
    assert_match "Please set the kubeconfig file path", output
  end
end
