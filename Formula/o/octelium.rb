class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "db732ca5e31da4b247232dfa7b880096d736762f98c90f62708278be256eb28d"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b61c23106f030afe224ba2fe92f678452b9248c80580e0f2582d7bc82fb3255"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b61c23106f030afe224ba2fe92f678452b9248c80580e0f2582d7bc82fb3255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b61c23106f030afe224ba2fe92f678452b9248c80580e0f2582d7bc82fb3255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8f30bbb5e27db2de14f0bd53f7e5776835b7dab6aabc20785751721ac3b901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "288c6feace88626a69b4ebf2d58fe8d7a062dca5a10c1b33ca851308236c1637"
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
