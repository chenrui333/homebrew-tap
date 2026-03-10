class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "fbadf693bed6f4e0f15130861ec9c1fe89db801bf0648bbdd891402fed42a5cb"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5618985757b7376424652b048af13e9c85af3ff5beaf18fd87b2e9f8aa572f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5618985757b7376424652b048af13e9c85af3ff5beaf18fd87b2e9f8aa572f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5618985757b7376424652b048af13e9c85af3ff5beaf18fd87b2e9f8aa572f0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b29194ed8a2b4179097ab2f566cae2a6adcdd9e091eadf76e44bb6fc28b10fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3e12dfe7caef80881a895cf13997dbc3d5e2a5b8157cba7cd08651c5e80f8c"
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
