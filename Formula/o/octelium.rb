class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "371cb28bc8340d32263a6140273faeaa4bd003cd9ed6958c84d4737b2650b6c3"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "85ba49f6444f636d55743116e28e5705e62a97a4abe24256ee006d341ec34a8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac8b3ce3e687686e88236d946bd8b842f44aed32df73bbcdf7a18f49a3b5de18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac8b3ce3e687686e88236d946bd8b842f44aed32df73bbcdf7a18f49a3b5de18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e1e94850beb0ff9281791079a2e287bbcc0076436f8220d377b462ee521d0cf"
    sha256 cellar: :any,                 x86_64_linux:  "245e01533bfd067d7166e5b7ec3eecfa503bdba3a02da449a0f0b2143991f11c"
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
