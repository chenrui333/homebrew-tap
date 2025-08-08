class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "07c72f9088110b71509a6884a9aef4f4983bb092730966d823dc0f29cabcf9ad"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79b12ca51a5728417e3e6faec26c0023425e30627ea563320c19ba372eaed883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "125cc80124ff831f9a1912524aeddfed8839acdbe917dd88c70254222bf50ddd"
    sha256 cellar: :any_skip_relocation, ventura:       "4b9430eb283f3bf6f3c1381830adf8fa6752498ecd7dea8d63ecee705d8fca75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2840d3143392f8765c7890f462507e7d423a998f1b7071b11f85a5f66b2dc2f"
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
