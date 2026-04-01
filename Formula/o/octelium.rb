class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "d6fdc18edac0fab3dc8f54e5ee4d5340215a3b04c022a249785f3d155c06e054"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea97b5c2ab8546658fa6d5af1d4c0ced011c48c3a2f03224149a6361c360e057"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea97b5c2ab8546658fa6d5af1d4c0ced011c48c3a2f03224149a6361c360e057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea97b5c2ab8546658fa6d5af1d4c0ced011c48c3a2f03224149a6361c360e057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3973dc1bcb64065222b1fcd056fc727e809e3a4101b58a73ead52a7c5bbe27d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6816943c971df6f59a96f0605c485d70b639ed4485f443d0416ea31e17b98d92"
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
