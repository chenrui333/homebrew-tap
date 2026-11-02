class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.107.1.tar.gz"
  sha256 "f8715eac1cadfb11af58932306c9e3929ec8cf81f69e322565baf205ded1a370"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "218a395af32d9c58c31292072e20f8f3930ff9786f4336a4c462db7a49c4088e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "218a395af32d9c58c31292072e20f8f3930ff9786f4336a4c462db7a49c4088e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab0dc79f1cfadeba5065116e73ba3798c62e1ef2cac5c5f269b8e18aa1716cb9"
    sha256 cellar: :any,                 x86_64_linux:  "16f63787211d0c2ad4d4e00060980605e2990bea38dfd610ea40d8107e31d195"
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
