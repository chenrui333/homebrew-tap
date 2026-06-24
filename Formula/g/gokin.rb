class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.49.tar.gz"
  sha256 "72d9376a1f16959efc6281d8396cf56f8bc4abc4526769d7cfbcf3902c9e27cf"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b60b625d6c8397651158762ed5ef9e803dbbe1dd037d532ea7d3f5fb7c9a6e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b60b625d6c8397651158762ed5ef9e803dbbe1dd037d532ea7d3f5fb7c9a6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b60b625d6c8397651158762ed5ef9e803dbbe1dd037d532ea7d3f5fb7c9a6e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "866f0e578a81b4cf1614c5dc1801620bf042fd405336ab3ad33d437789ecf50c"
    sha256 cellar: :any,                 x86_64_linux:  "9ac9beb770806ac36de5c05bda597e72d21413e6972e5f2dd2170b9569922b8f"
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
