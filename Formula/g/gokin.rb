class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "081096181afcc97e4e0fca6988e6d6eb8ba87c83402766b129b2c437dd0ec889"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c5e8ff9dcf5da5306e7b6e81c0f7a4bfa19e57c42f40653cd65ce711d8ae324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c5e8ff9dcf5da5306e7b6e81c0f7a4bfa19e57c42f40653cd65ce711d8ae324"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c5e8ff9dcf5da5306e7b6e81c0f7a4bfa19e57c42f40653cd65ce711d8ae324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95e048d5d0f69d27e60f12799caa941da2f79e1907d7c48d0946ac8fded87ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "271624eb42ed13d7c863e8ed4f8c5ead537be7779467fe1366bec83b4e4da54b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
