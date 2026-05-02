class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "70be5737908d08ea6214bfd3a49a7683b4c1b3f68a1ef141d81d7b04a78e6f09"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccbe28974ff942fb8de3991df032f74b91eec08ae1fdf4515e670e8a55796eef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccbe28974ff942fb8de3991df032f74b91eec08ae1fdf4515e670e8a55796eef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccbe28974ff942fb8de3991df032f74b91eec08ae1fdf4515e670e8a55796eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04a581b4b1ffdada060638ec80b1f0462046f1231233d5fcff1c3dc78d1731e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fabcc8d486de6e4aa9155964bb7dd3ed1b5bb935507d9d86ee60fd0f69f815b9"
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
