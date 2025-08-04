class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "32ced144210b4242d19ac2276def592f8c8c63386e39e5bd9570f715d8bff5bb"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab2fbfb4e55c1c71b177ac291e38c76705438a7d764fb2afaa87df09781fdf72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52ea5ff1ca76bbcb71701d5ab4ff2629040ffce344eb6007f09399b3db30b9cd"
    sha256 cellar: :any_skip_relocation, ventura:       "6d29b0d42306d52581c836998ad856cdd8ad5d8708013ce64b606f6373ad9696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "392017d7ab14325c512627979ba7bf9a0081ba536edb35024d4844d8d202b1de"
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
