class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.106.1.tar.gz"
  sha256 "d54201ad10a1c1a0a9fbd1d64794ea970dbb15a6e6e63cc0b0a62b58a8ae1746"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ccc7f9db6aa0107213fc4723b2645601c08833d6c4d9e9ef177a069d0c9661b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ccc7f9db6aa0107213fc4723b2645601c08833d6c4d9e9ef177a069d0c9661b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3479e35e64761c88d9d798d522ed46ac0eea04efd6dba050cdbb4af51dbc7e35"
    sha256 cellar: :any,                 x86_64_linux:  "451169804b5a468805fd83d5376d1f040f79351ff9fea37e8c7c4eb8b4efab0c"
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
