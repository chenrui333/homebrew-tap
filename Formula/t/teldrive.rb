class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/1.7.2.tar.gz"
  sha256 "405cac8b22139130173fa8d2608f2ee480e72fcbe40b48dc150f821c3b958943"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f4b26adb9ca025dab2fefbe03c9d10a5d1e26592fd4d6981a0d53929cec14eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f4b26adb9ca025dab2fefbe03c9d10a5d1e26592fd4d6981a0d53929cec14eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f4b26adb9ca025dab2fefbe03c9d10a5d1e26592fd4d6981a0d53929cec14eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d9f26b8f1ccb015dbcf78e2ef312df1b51d02a70c981f01c583b938182ea1c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47cf72ab158a33448df3c0bb58b997bcbd04115e293725b6eddbf90ab52eded6"
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
