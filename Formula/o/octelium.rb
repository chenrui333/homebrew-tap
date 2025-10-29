class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "fcf6209f81481ae98a1f09368739757aa9cdbc1ef965d5fdcbcf95a26a05b076"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56c0f408cb0d3f0e4995141e9799c3679e299ef06351f037115dfc9087f98215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56c0f408cb0d3f0e4995141e9799c3679e299ef06351f037115dfc9087f98215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56c0f408cb0d3f0e4995141e9799c3679e299ef06351f037115dfc9087f98215"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f191e20979c0208a574226f0d382fadcc0b4d29fc81574775df6b8ab0e726a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb398e2ceec7ab0185b6fdc48a63ee3d2e827d290da80a3876517402cdb1fc7"
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
