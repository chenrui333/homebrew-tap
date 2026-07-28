class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "9371cbe49964572669d57c50fa995101a5fbcd430eee06755594758c5557a248"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d03bbedbebdba66a5864138cd8d99e3137734909c3eb49d8666e3c906463282"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d03bbedbebdba66a5864138cd8d99e3137734909c3eb49d8666e3c906463282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d03bbedbebdba66a5864138cd8d99e3137734909c3eb49d8666e3c906463282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5348f73d2d08cc2188aa4d01c3c5017e2314635a4c3876ee2a6bb5adad3ded8b"
    sha256 cellar: :any,                 x86_64_linux:  "cecdaa201a564c32a722537e1fddb990f5166182ffb18f64bbfd0144b805fd35"
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
