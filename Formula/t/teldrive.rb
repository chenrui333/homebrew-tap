class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/1.8.3.tar.gz"
  sha256 "731126690b81f96e241e07ae45330dffb8b4a6df6ccce153f262667a404ca4e3"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75ce7410efcaddc6a40399e7082d7b5828a7340c154d6aa4a671723e8d5668a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ce7410efcaddc6a40399e7082d7b5828a7340c154d6aa4a671723e8d5668a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ce7410efcaddc6a40399e7082d7b5828a7340c154d6aa4a671723e8d5668a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ea67998302612f175f5282801576f7362f04cf7267e3b5bad80adba1011238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72c7a12f77dc624da51badaf034a4b41fa370b5417685bc9bf2b8f70f6fb5f6"
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
