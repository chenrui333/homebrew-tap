class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.12.tar.gz"
  sha256 "02d6e5cbffb9f60afa138655a44d16a0f448918d2ff386d8451fc8b7b8acff96"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0443c5fa1ffa01423ee6ba4df29c998ab16c8a54283b10cb9f169c1b2a65cf69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0443c5fa1ffa01423ee6ba4df29c998ab16c8a54283b10cb9f169c1b2a65cf69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "791130f1ad956fbc04b8857ad13e1d817dab4c00bc657b698b5df1c6912f2559"
    sha256 cellar: :any,                 x86_64_linux:  "4861a9067f66d4e811504b81b999c99a644c3f69683fc7e25996a4747fe48cb8"
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
