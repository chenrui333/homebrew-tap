class Octelium < Formula
  desc "Next-gen FOSS zero-trust platform—self-hosted VPN, ZTNA, API gateway & homelab"
  homepage "https://octelium.com/docs/octelium/latest/overview/intro"
  url "https://github.com/octelium/octelium/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "44639e4801c3b4c1ac247099079750ca90c91a344203753dd617db7332b19b4a"
  license "Apache-2.0"
  head "https://github.com/octelium/octelium.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d1b301b037c9e9d0b086c74deac93e94d137fe3501b1191ba91135eb3f70cc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d1b301b037c9e9d0b086c74deac93e94d137fe3501b1191ba91135eb3f70cc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d1b301b037c9e9d0b086c74deac93e94d137fe3501b1191ba91135eb3f70cc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7539ff67a7d4e399ab575f797d581b18ad869d5375d44f45f7d983e6741a9d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ed468f16b408ceab466557d597d19b28ba5520c43078611ccd20176931e3693"
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
