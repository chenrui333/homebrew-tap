class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.0.tar.gz"
  sha256 "177ef332929ebaf3b787950aa9c028fc2654acf9afdc9a9b6aadd0aabc09cd69"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6041a417411badb6b21c96a6ddef563fd3ee8e8b34d7d95cfa93adbf28875337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6041a417411badb6b21c96a6ddef563fd3ee8e8b34d7d95cfa93adbf28875337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "598f2567170005b763e353f45b746197bb2496f3341288d7c74ef9370a2ab435"
    sha256 cellar: :any,                 x86_64_linux:  "6c01f7cdecca18eda4e4cfb62866a981eae7515c898830d8914bbad3169e8b18"
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
