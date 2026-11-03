class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.109.0.tar.gz"
  sha256 "b91ae3883a6c5bb994e796294214864f53ea6aa4a3de5f4b755cb5d5672adb92"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f74071c4b17f5893443d912e7d16fa2c766dc706974c71818f06f931e521887b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f74071c4b17f5893443d912e7d16fa2c766dc706974c71818f06f931e521887b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ecc5d448a9e53bc7394319e77e00b712ecca816cb77933d80003f187784b670"
    sha256 cellar: :any,                 x86_64_linux:  "40dd2e3528deaa4e5eb6d258c52255b70ce1e7b0f822f0b3b77e8972036cd579"
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
