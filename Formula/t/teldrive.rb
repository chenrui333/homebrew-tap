class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.13.tar.gz"
  sha256 "50c58e884214e20eeba29d8c3b9587ecc5d4b5b876a5fdc22be6011a70d5c6c0"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5edef6497673de9bfb62cbfe2e0edfcb44df990949e1958676dc3f6bb6ba08f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5edef6497673de9bfb62cbfe2e0edfcb44df990949e1958676dc3f6bb6ba08f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb10145755bf215a9510f50716ebab907553b945900cb34ec551e5bde953bf5"
    sha256 cellar: :any,                 x86_64_linux:  "d941ecae4e1698ab8295486254a45cf2cf7468b1935f21b7e233ce4a540c2715"
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
