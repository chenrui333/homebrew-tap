class Kat < Formula
  desc "TUI and rule-based rendering engine for Kubernetes manifests"
  homepage "https://github.com/MacroPower/kat"
  url "https://github.com/MacroPower/kat/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "20fb87893ff1c60c4a642966d00d2b468e7946988d12ac1f7167c9a867800d4c"
  license "Apache-2.0"
  head "https://github.com/MacroPower/kat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c9e9cf77bbae407a0bdea1a420df544c8f708a9256f38dc96a055b364a0f6c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c9e9cf77bbae407a0bdea1a420df544c8f708a9256f38dc96a055b364a0f6c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c9e9cf77bbae407a0bdea1a420df544c8f708a9256f38dc96a055b364a0f6c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1e7e25eaa8fd790dd0bd9ba5a7e4a6e099c46c8b64d6deec8a64f5d3d8cbdf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41bbc25acab4a8da83f50bdcbfef376e7d6d10e85e86dff3f17707e473124f6c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/macropower/kat/pkg/version.Version=#{version}
      -X github.com/macropower/kat/pkg/version.Branch=main
      -X github.com/macropower/kat/pkg/version.BuildUser=#{tap.user}
      -X github.com/macropower/kat/pkg/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kat"

    generate_completions_from_executable(bin/"kat", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kat --version")
    assert_match "profiles", shell_output("#{bin}/kat --show-config")
  end
end
