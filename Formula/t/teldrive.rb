class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/1.7.4.tar.gz"
  sha256 "ff3738cf912f3e53a116421523a2501f7af0a9f231ccf7e767c39ae2309f9c36"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d172a7d937de0342650da93a3c4aa07bcd67856cce2076f26a081936c364548e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d172a7d937de0342650da93a3c4aa07bcd67856cce2076f26a081936c364548e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d172a7d937de0342650da93a3c4aa07bcd67856cce2076f26a081936c364548e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b2c15255df987789347ecc4c13407a1f5132a8140607e0aab13d67885ffba3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea2a30e71e1cc562cc59f54756300f60005f63d7755954669c0cb2aa93cf04a"
  end

  depends_on "go" => :build

  resource "ui_assets" do
    url "https://github.com/tgdrive/teldrive-ui/releases/download/latest/teldrive-ui.zip"
    sha256 "332846ee65061adca2a7213fbe01ec1f182e20bde9db498407061c6d4e4228b5"
  end

  def install
    (buildpath/"ui/dist").install resource("ui_assets")

    # generate API code
    system "go", "generate", "./..."

    ldflags = %W[
      -s -w
      -X github.com/tgdrive/teldrive/internal/version.Version=#{version}
      -X github.com/tgdrive/teldrive/internal/version.CommitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"teldrive", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teldrive version 2>&1")

    (testpath/".teldrive/config.toml").write <<~TOML
      [db]
      data-source = "postgres://user:password@localhost/dbname"
    TOML

    output = shell_output("#{bin}/teldrive check 2>&1", 1)
    assert_match "database: failed to connect to `user=user database=dbname`", output
  end
end
