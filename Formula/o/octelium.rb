class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "cd937ce2ef8b25f37390aa49f9ef9e0c6161231c3265dea99789ef2aadf433a8"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "227c54a90df96e1ee1d397762b5cf747600c1e0730a74bd1ccca5fd825987fc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227c54a90df96e1ee1d397762b5cf747600c1e0730a74bd1ccca5fd825987fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "227c54a90df96e1ee1d397762b5cf747600c1e0730a74bd1ccca5fd825987fc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b5eca59a088f8703f0b5c733c10d2493e5ae7a9aad2324e3ef19768e5129d3"
    sha256 cellar: :any,                 x86_64_linux:  "4e38fc48cebb03b4ee6fa8415bbcbfa5a2253151c0c5818dfd320c3e9ed2f02b"
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
