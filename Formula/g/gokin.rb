class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.80.20.tar.gz"
  sha256 "2c9c6ba6973dff40eeaf0ecee34eccd8517232b75efaa1f6b1949785bf805cfa"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50fb390cd3e3ce987e03d0ae9905c9801cd78568fd5b764a64c94a269c2d99b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50fb390cd3e3ce987e03d0ae9905c9801cd78568fd5b764a64c94a269c2d99b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50fb390cd3e3ce987e03d0ae9905c9801cd78568fd5b764a64c94a269c2d99b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ddc9e2e2f5dd108a40dd0474058f206ea4d4108d07ad2915e95641289f25e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f84c822f94530cf05064f623bdee836c00a14e1c80c72bb47bcd60eafc05d4fc"
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
