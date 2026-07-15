class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.89.tar.gz"
  sha256 "c7f3969677843348a4f99e0a04f39fe77d5525c2bf7dd4c16da9071fb91ad255"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "837a77a8a3157f39a940d801be0b4dd82be3edaf0a69c6d4691acb4319efc9fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "837a77a8a3157f39a940d801be0b4dd82be3edaf0a69c6d4691acb4319efc9fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "837a77a8a3157f39a940d801be0b4dd82be3edaf0a69c6d4691acb4319efc9fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17e6543ef731a2b811e1f084c58589a0f819acc604f6d248bbb8e11ccb10c2e4"
    sha256 cellar: :any,                 x86_64_linux:  "104d32e10b16a363d412b33f4b9659964dc72f9356d50715fa341300eefb3ef6"
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
