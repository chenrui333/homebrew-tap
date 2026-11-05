class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.111.0.tar.gz"
  sha256 "fd20618c3b1eef3a3bcff8726be7c49c003d50fa8291a76e3f47d5eda74dcaf5"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ca6c46f07dc06ffea289c4bb9dd6242a752e2440aff6e637f49742ad224cae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca6c46f07dc06ffea289c4bb9dd6242a752e2440aff6e637f49742ad224cae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a180a180b0f98d56d19e81eaf5d2fc7ad8a15a8c9ea0673db5beaf3813e949"
    sha256 cellar: :any,                 x86_64_linux:  "c43bfea684b534a179f0586e1e7063d00baa9a06084ee1dae4db273158333bc2"
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
