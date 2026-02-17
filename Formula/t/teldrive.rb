class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/1.8.3.tar.gz"
  sha256 "731126690b81f96e241e07ae45330dffb8b4a6df6ccce153f262667a404ca4e3"
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
    sha256 "bf3e9c3c2541eb9c222adfe12275480591a0d20a6152b439951729649f854739"
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
    assert_match "Failed to connect to database", output
    assert_match "failed to connect to `user=user database=dbname`", output
  end
end
