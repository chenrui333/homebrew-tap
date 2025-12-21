class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "44639e4801c3b4c1ac247099079750ca90c91a344203753dd617db7332b19b4a"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd1822929a881ddcfd50aff1a3242dffee6cf3320c7dabff49b75ebcfc283fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd1822929a881ddcfd50aff1a3242dffee6cf3320c7dabff49b75ebcfc283fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd1822929a881ddcfd50aff1a3242dffee6cf3320c7dabff49b75ebcfc283fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7459d20b9950b6adfa97e5f01219d88655d4aab06f06d6093d101c89aca8d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e47e0822eac8ee724458e8c9e2b14daee0b1c91fbd72e8801e05318739baa9"
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
