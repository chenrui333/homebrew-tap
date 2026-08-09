class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "e12e2aee2b83114eea7882603f74790de739c34a150dd2158b554c86f252fb1a"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c5b2280e3a727c06dbb496f77fd213fa55329cf44440216ed0d7d9dc1a48797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c5b2280e3a727c06dbb496f77fd213fa55329cf44440216ed0d7d9dc1a48797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c5b2280e3a727c06dbb496f77fd213fa55329cf44440216ed0d7d9dc1a48797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9efd9f94345acc65fa02cd2e7aaef5ab93ea06fc8089bec427c0adc195a8291e"
    sha256 cellar: :any,                 x86_64_linux:  "17b758c14174a3e517c228a346c0635c862f5074c572a9cf09ffbba596822510"
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
