class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.104.0.tar.gz"
  sha256 "3a665235d6b84404c264b6f16efcf3145065dce1ce651a73e4396e83c8af13ed"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b6721013fb06cbc0ed24cca67c8c2498dd250a10a204b365eb0925a527a01bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b6721013fb06cbc0ed24cca67c8c2498dd250a10a204b365eb0925a527a01bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fea6fca412a1910ea3b2b17012a979ff463f32f8e22d308b0fca1ec75379f39"
    sha256 cellar: :any,                 x86_64_linux:  "b05cafd425d5e77971075b729ffcaa29aaf4dd16dd257cdac1b1d07a521e419c"
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
