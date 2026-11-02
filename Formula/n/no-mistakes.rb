class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.108.0.tar.gz"
  sha256 "3b9b0d00417f30b991ab352b8e0fc8170bd08fa958d5dd0cabc12f7dc0ebee94"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe10b7fd5714a4296f9470a9ba5ba7c32e196408c704a5aeb6d6adc869d5b71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe10b7fd5714a4296f9470a9ba5ba7c32e196408c704a5aeb6d6adc869d5b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c4180f2e81b58d45fcd8e04c1bda712a426110f5aee5afe20ae55a3d37b6ffe"
    sha256 cellar: :any,                 x86_64_linux:  "a1da971bf284d5060d9e21d36296dc98c1bdafc6fb462b97c608a399ff11ff3b"
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
