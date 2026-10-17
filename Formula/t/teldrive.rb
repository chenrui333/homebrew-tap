class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.7.tar.gz"
  sha256 "ef0c330f5228e8a228a8181ab8f9ea3a98575ac310e068be039e039f2e6fe32e"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4108e193fb4ff0ba5bba75289584bf16106ae57b4a5edd0dc9cd7b292477eaad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4108e193fb4ff0ba5bba75289584bf16106ae57b4a5edd0dc9cd7b292477eaad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9345d2e9eeefe4b1d628ec7a04299ca862d13a01037148e80c7d2f5c55ae78d"
    sha256 cellar: :any,                 x86_64_linux:  "78cb37e68ce65125e1b9dfd1b020246d9cd427c4ba1a0070144d04ee12e7c66c"
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
