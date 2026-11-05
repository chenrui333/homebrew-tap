class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.111.0.tar.gz"
  sha256 "fd20618c3b1eef3a3bcff8726be7c49c003d50fa8291a76e3f47d5eda74dcaf5"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "483ac31ad921e5b99ea9c8b19a2e34eee9053e5ae28d9e60c080ab57a54258df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "483ac31ad921e5b99ea9c8b19a2e34eee9053e5ae28d9e60c080ab57a54258df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2539e9bb717f1ac2bc3bb71bfe7430224cc5f06f6aa11f20578618e013b811e"
    sha256 cellar: :any,                 x86_64_linux:  "15ab1e13a0d68cfb2ac54a5560a16d9b5f27ea9feff18928fc2ddf581ef53f98"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/kunchenguid/no-mistakes/internal/buildinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/no-mistakes"
    generate_completions_from_executable(bin/"no-mistakes", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"no-mistakes", "daemon", "run"]
    log_path var/"log/no-mistakes.log"
    error_log_path var/"log/no-mistakes.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/no-mistakes --version")

    assert_match "not in a git repository", shell_output("#{bin}/no-mistakes status")
  end
end
