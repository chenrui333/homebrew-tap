class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.104.0.tar.gz"
  sha256 "3a665235d6b84404c264b6f16efcf3145065dce1ce651a73e4396e83c8af13ed"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "007dbc2f8150a30fc039d68fe4dcb0d11db227d64c1e7c47d31ba7ddbd142278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "007dbc2f8150a30fc039d68fe4dcb0d11db227d64c1e7c47d31ba7ddbd142278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e5456b6de68cd24af363b1665c66d4d671794400d5166e45b941ba20d3acf6"
    sha256 cellar: :any,                 x86_64_linux:  "97257a860ab955f2ca8a95ec9db25ebf84b9944e68e321474b2caae6c7226828"
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
