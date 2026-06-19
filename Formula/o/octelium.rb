class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "fd2c17528dbbda3361efbd678b9d67597c472242ea404960f58177fbe607ec5b"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8756f9dfece18542feef7c409958916eaf6471e0422dadc8745781c9c5d8e07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8756f9dfece18542feef7c409958916eaf6471e0422dadc8745781c9c5d8e07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8756f9dfece18542feef7c409958916eaf6471e0422dadc8745781c9c5d8e07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5121ba72b813b08f43c433c26a212b0c8efe33c2556ce099321b9c80385295a2"
    sha256 cellar: :any,                 x86_64_linux:  "fcfb0ade2af6dc9da89b759b2c135aa12673ee1405ff48f139538455ab72211a"
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
