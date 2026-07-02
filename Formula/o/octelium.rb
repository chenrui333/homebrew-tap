class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "443dc86687bd40a7feef9080ac65af89a692c00f00c6b9ed689d6916fea0ec0c"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4e4a0f812a22d37acef7b1b078586567d23139bb7275769d8890bbcd71b11b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed4e4a0f812a22d37acef7b1b078586567d23139bb7275769d8890bbcd71b11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed4e4a0f812a22d37acef7b1b078586567d23139bb7275769d8890bbcd71b11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a02860b1e9e3f45588ea8abb9a359a715239005bb3aed8446dc4f2701b500f"
    sha256 cellar: :any,                 x86_64_linux:  "57cc337f0a9c5fa1248806033c57b7d13f8bd4be2b5180c1254fd5473562df6e"
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
