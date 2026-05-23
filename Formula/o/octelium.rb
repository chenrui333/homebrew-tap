class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "b01846a18316f09fef7fc562b466a5ae8a9cc91b24d5f4bc4eb803cbb4993f83"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e169c92a1f0dd92093836444b7ac4b7c3816fb33ce47ac6d24e6c2d82b0cb71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e169c92a1f0dd92093836444b7ac4b7c3816fb33ce47ac6d24e6c2d82b0cb71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e169c92a1f0dd92093836444b7ac4b7c3816fb33ce47ac6d24e6c2d82b0cb71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2c12fa00159a0b4626ec5632e94b5c14a8d02b6b1b7c8914779e2e0de16d01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "083dcf0ac211b0f3c0efad5592a05a1c0c14a9c83f27af3684bae3d43c36cc57"
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
