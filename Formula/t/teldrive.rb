class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/2.0.9.tar.gz"
  sha256 "9b020f13031bcff7ec204e0a1a30cdbe2e382f1068439a98aed8090c8886e467"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05d11b4fcf22a1a45289e57aca8bb03dcca3afd334306235b974e8dd900eaf14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05d11b4fcf22a1a45289e57aca8bb03dcca3afd334306235b974e8dd900eaf14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17b8025586f39c0fcd97d0b9503543ac0588fecbc61182b86df5055de0eb7cb5"
    sha256 cellar: :any,                 x86_64_linux:  "fc13565f82a5cd0f2613db73f00d623a0110c1ac04f566b7e4ea803f8dfae2b2"
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
