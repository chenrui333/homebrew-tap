class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "900a03f098cb59b9a788cd4ce5b67c0f91dd468429a283993f2d43c4d57faa10"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff2f051109a5455070c59727c5267333e46bca1974a7751e87d099fb7fa16cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83313dcef3f15050e477141a11e4135feacccf43fa7ecb6920cd8d2e2fcc612"
    sha256 cellar: :any_skip_relocation, ventura:       "004b556efbd1e210aef408e976189ec70bb7f158e09bb5e12de562fa5a016d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26299d7031036dbb1a623acc0e4a1b106bf58df47dfa1f0f4772d74e8ab9d92d"
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
