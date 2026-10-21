class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.9.tar.gz"
  sha256 "9b020f13031bcff7ec204e0a1a30cdbe2e382f1068439a98aed8090c8886e467"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36c7205ca4600404c608a67358f51995ec807dfdeedebd7838c2b02fd7504be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c7205ca4600404c608a67358f51995ec807dfdeedebd7838c2b02fd7504be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7f74b4a315198e28210f8ce770cd1749b256d48e5da4394c186c857e1b53e8d"
    sha256 cellar: :any,                 x86_64_linux:  "c2a4de847be38c0f54f136d2d5bf79e920bfb384e5f6fc1a813bca2bbc66dbef"
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
