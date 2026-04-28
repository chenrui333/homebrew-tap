class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "d6c95147ebc3fa7345e024684a51a9052907118dbf9e48d158d50ce7b92c0074"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66e8e37d60bce47814d49722fbcd5812c44c96717e4757af618950d3411a5937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e8e37d60bce47814d49722fbcd5812c44c96717e4757af618950d3411a5937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e8e37d60bce47814d49722fbcd5812c44c96717e4757af618950d3411a5937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a6f058400259ed3961a6331a447bc7220d68e5474953ba1beff2b5dd506dfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2d968aec5522aa636ffb73c0b030c57128e5ac8fe6e1503e57d9b71ca3bbb7"
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
