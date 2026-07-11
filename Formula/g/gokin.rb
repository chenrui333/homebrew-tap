class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.79.tar.gz"
  sha256 "1e2662d39fe472c1ec459b0b0c282689565c12bc0fb15ff757b9c226a80e48da"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28a3fb80833c3ae2b79575d9bb971fd6fa9774eccb249e058684fe871970f02a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a3fb80833c3ae2b79575d9bb971fd6fa9774eccb249e058684fe871970f02a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28a3fb80833c3ae2b79575d9bb971fd6fa9774eccb249e058684fe871970f02a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b69fca50be0e465fdd8d2668434706c6025d118f6afc1386d3ad59bca590b35c"
    sha256 cellar: :any,                 x86_64_linux:  "63c55689a02c93b84ba88c4afe54eb745969af0c56126bbb5df6f576dd8cf6e2"
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
