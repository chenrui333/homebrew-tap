class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.44.tar.gz"
  sha256 "f90c746e7bdc68a68c9d924db805016ab995d302b4585fbd7ade2a28e33158b1"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79dc1b61786e8c871fbe724869ac2abafdc755081b569d9e504af122ae342e3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79dc1b61786e8c871fbe724869ac2abafdc755081b569d9e504af122ae342e3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79dc1b61786e8c871fbe724869ac2abafdc755081b569d9e504af122ae342e3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c8dfa2aa76b995d566b2d9abd7e93a4be60fa07ea0329764e7f92cb9134516a"
    sha256 cellar: :any,                 x86_64_linux:  "1a250207b8ca0772aaafd7817235f35536836d07ea178fc63f5f2060e1b39e1b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
