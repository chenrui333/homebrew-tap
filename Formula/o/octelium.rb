class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "07c72f9088110b71509a6884a9aef4f4983bb092730966d823dc0f29cabcf9ad"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aaadfc8451b211ff4c23fc2d8e5d4523e8d906b7a91c60a2a8643ce1c344d30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28a26eca9aea0b0d2721493f08de444c7f782d078a4527e97036e837bde6e6aa"
    sha256 cellar: :any_skip_relocation, ventura:       "cd5e82fa33aafc4ed588c308d1041babdfaa222a177e67d7098458ff0e77a83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7543283ce9d60be5f87f285eb1908551ff8862ebd844e8e7b56672cfc8503f1"
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
