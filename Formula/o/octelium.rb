class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "fda636e47c4e759bdf763e3beae926b96e043bd9a98a366ce06909b34cdf36f5"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eae11cc1b5aef6b1c545229bf607ed23d2c6956a43a65c51312281a075d72a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15082cd4191e65df48f04c917a6cb9fb8a68065d19ba34fd4b0d5cfc5ab9980"
    sha256 cellar: :any_skip_relocation, ventura:       "2b4c50ab6b4f6753c1683174ad8152888072bacc5d0b54ec495c9d04002121af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cdc01e2c14139328833117a5377097ece632ab3c1fd05130a8d71e9401cf2b8"
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
