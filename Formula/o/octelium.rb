class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "1d35fefd2b573cd92b5e8f40a80c5e5ba14c26b5aaf8f3e8ff68a8be41c86210"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95234319d518b9b152e2ac97616573257c80bf06d2617abbc5e051f32fd80a48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95234319d518b9b152e2ac97616573257c80bf06d2617abbc5e051f32fd80a48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6970501267fbe3ba021c29be9a4f0fec431fbabe9e1251f7366436922834a6f1"
    sha256 cellar: :any,                 x86_64_linux:  "e312018c457c168dc0e99453dc8829e53f038bf5427dcaf311177dbe25a16970"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
    assert_match "Please set the kubeconfig file path", output
  end
end
