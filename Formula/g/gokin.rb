class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.50.tar.gz"
  sha256 "fb1c16bf531ac0c111b8ed14276b93269cc12d3c375d3b2b3bf82a57adfd6f56"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ee12bf2570e8f5b746ada7755b00fec2e46037b12d2312e544c95c95c40063c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ee12bf2570e8f5b746ada7755b00fec2e46037b12d2312e544c95c95c40063c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ee12bf2570e8f5b746ada7755b00fec2e46037b12d2312e544c95c95c40063c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5001a8e0b29619944d165b1e703cae56f5cc496836ba7f03eeb0895d8fd621d1"
    sha256 cellar: :any,                 x86_64_linux:  "1ce6be6afa73ebd9da4428f22bbd3f7b47322bc6e96c0fc603304c6338fff524"
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
