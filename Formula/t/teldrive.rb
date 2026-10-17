class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.6.tar.gz"
  sha256 "9864451015e4c059b57164ed68d48245144c161be6216f671c6f014516c9687c"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "444562ea5c992b9cace87fd8e957418a228ea35bf644ec92a659da0bf13d3bce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "444562ea5c992b9cace87fd8e957418a228ea35bf644ec92a659da0bf13d3bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a333a2690acbbf56bbbea733bf4c5ceeca7d706aa68b056a5edc9c27ff9b0366"
    sha256 cellar: :any,                 x86_64_linux:  "74075f5327d15338c956de3f73c74096e5cc02fc3a8c34fb4cd58698e24551f6"
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
