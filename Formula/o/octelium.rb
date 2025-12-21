class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "44639e4801c3b4c1ac247099079750ca90c91a344203753dd617db7332b19b4a"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1091366bed254737927ff6713745a2f0abf95ea211fe4cedde199444e1359135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1091366bed254737927ff6713745a2f0abf95ea211fe4cedde199444e1359135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1091366bed254737927ff6713745a2f0abf95ea211fe4cedde199444e1359135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e98de2c1a964130a690a4ed0187f52693af8f1e623f13790d8f7d88a175959c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dead02a6dea73f587f8456ed00ae2ad7047ddf0dc4cfd42765ff776c01bcd751"
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
