class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.14.tar.gz"
  sha256 "75403c13f077e0400211e045d30d112ce746aa76a072aefffc317f19373d2c79"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85d879264e8e7387c9481c33056e124d13e111eb6621ba09eea6d20b128c70db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d879264e8e7387c9481c33056e124d13e111eb6621ba09eea6d20b128c70db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce02d1614c22dc8f0210801904af256f6949185be8c743abff22e8823163ad85"
    sha256 cellar: :any,                 x86_64_linux:  "c0dd1525442bec5177e8ed08014ad8d7a981523658ea4c7bc66eb4f6755a0c0e"
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
