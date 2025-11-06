class Teldrive < Formula
  desc "Utility to organize, manage, and sync Telegram files locally"
  homepage "https://teldrive-docs.pages.dev/"
  url "https://github.com/tgdrive/teldrive/archive/refs/tags/1.7.1.tar.gz"
  sha256 "e1c60007eeb1e83b003dd3e80b74994c5b79b66ca3e554fb0c167058aa62b0d6"
  license "MIT"
  head "https://github.com/tgdrive/teldrive.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d50aa46bae06d005d4d21f9c019ef0b5d3c265e87c2c38cfd24436a5948a5358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d50aa46bae06d005d4d21f9c019ef0b5d3c265e87c2c38cfd24436a5948a5358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d50aa46bae06d005d4d21f9c019ef0b5d3c265e87c2c38cfd24436a5948a5358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82ef4a1361498bedd346b4c83b9edb2f4456b42ac6bac7b6f9aff87e9a61d219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8feb75ac3dbae678e75739a78f2d954551aee78b9b3f277a4674066e2178229f"
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

    generate_completions_from_executable(bin/"teldrive", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
