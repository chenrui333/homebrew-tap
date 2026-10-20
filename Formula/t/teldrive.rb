class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.8.tar.gz"
  sha256 "3336eeab8613dbd64dd594f0a5dbdd7c2a862f179ca952011e608d32f74ff1fb"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9561eee87a35b26a37a1fab882f8daff3ae7227aa4eadf959d6f9f41a0e067f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9561eee87a35b26a37a1fab882f8daff3ae7227aa4eadf959d6f9f41a0e067f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e1a8a9136d000fd966514f72357ae7f3f3038b685f951cd187d2038b428ab61"
    sha256 cellar: :any,                 x86_64_linux:  "5813b51a5af893f80bc91a447683b21baccb626232297ada05f6acf7b7ac13bc"
  end

  depends_on "bun" => :build
  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "bun", "install", "--frozen-lockfile", "--cwd", "ui"
  end

  def install
    system "bun", "run", "--cwd", "ui", "build"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/teldrive"

    generate_completions_from_executable(bin/"teldrive", shell_parameter_format: :cobra)
  end

  test do
    assert_match "teldrive #{version}", shell_output("#{bin}/teldrive version")

    (testpath/".teldrive/config.toml").write <<~TOML
      [database]
      url = "postgres://user:password@localhost/dbname"

      [security]
      signing-key = "test-signing-key-0123456789abcdef0123456789"
      data-key = "test-data-key-0123456789abcdef0123456789abcd"
    TOML

    output = shell_output("#{bin}/teldrive check 2>&1", 1)
    assert_match "initialize TelDrive", output
    assert_match "failed to connect to `user=user database=dbname`", output
  end
end
