class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "a0b5a061e4a3c25fe01fe008b75c4d22dc9880ab6eb13c1ac603650c9507702d"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e871c86c2fac706ab1b86af1342fb8b8b8f236154ea70f72a1d2ffec7c969643"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e871c86c2fac706ab1b86af1342fb8b8b8f236154ea70f72a1d2ffec7c969643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e871c86c2fac706ab1b86af1342fb8b8b8f236154ea70f72a1d2ffec7c969643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "213edda8ce30f59da825cf5ec43947b2b3e3c61ae91110da46b43f7ee536fb7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af6358ab4edc075173192e8139e9522122ba76b569fc9dab3a954cd6c940ea20"
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
