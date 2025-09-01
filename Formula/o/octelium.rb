class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "fda636e47c4e759bdf763e3beae926b96e043bd9a98a366ce06909b34cdf36f5"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d19a2eb4031b2444de0d1268e0000a8cfbd1423eea9bc97b3d2b01ead2fee943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90e331c8b59929ac027f2ca3231948149c2c4732206c9127f6360c6a5bdefab"
    sha256 cellar: :any_skip_relocation, ventura:       "8cc3db0507c5777dc122ea68c5741de6282c095596b01cd0213af975ced78c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4e0ebce7a997d3ee56b268f0404c558fd24b857243e539d9d45036529f3823"
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
