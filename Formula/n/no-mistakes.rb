class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.106.1.tar.gz"
  sha256 "d54201ad10a1c1a0a9fbd1d64794ea970dbb15a6e6e63cc0b0a62b58a8ae1746"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6a1e0671da2bb4fd266d7eed59c185d05632d124a49193619f19c34b1cfe28a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6a1e0671da2bb4fd266d7eed59c185d05632d124a49193619f19c34b1cfe28a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63fcafc65e7d625a3313b20d6c86513c6f4ad908b00445c8302ac9341cc222ec"
    sha256 cellar: :any,                 x86_64_linux:  "d2c548ce8a1f55190329a1c2a92f953152467d6ac430dc451f1f7addc5164788"
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
