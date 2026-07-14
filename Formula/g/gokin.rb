class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.87.tar.gz"
  sha256 "90ac702befbb8db5335b4ca83330a47e1cf83fa7647e756dc674c5bce0e5e260"
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
