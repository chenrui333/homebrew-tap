class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "05e47cc7acfdaf99d6ac4161afeb8e0f703378b5ba46366080d7582ac4b42b62"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "364631d6b55342d7184d979c231312fc9d92b0ab6731d3c645399a3a3030119b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364631d6b55342d7184d979c231312fc9d92b0ab6731d3c645399a3a3030119b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364631d6b55342d7184d979c231312fc9d92b0ab6731d3c645399a3a3030119b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c197576369ddf5e8c929dbbffe927664b0b024c41d2360eccb18eefc937d4c9"
    sha256 cellar: :any,                 x86_64_linux:  "ac324ac1c686bb6afd66d49371881e41d51bf9cb43f7dc628f7b9705e07fb543"
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
