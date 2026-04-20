class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "2c21471c88a63f1985f9cc0ef8ea466678f81e212967037a010ae5eef7128536"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a6e9aaa899f6c6fc5c1e2691781da102247979865ea3afbd7cba245c0014e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a6e9aaa899f6c6fc5c1e2691781da102247979865ea3afbd7cba245c0014e88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a6e9aaa899f6c6fc5c1e2691781da102247979865ea3afbd7cba245c0014e88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a9da48e7db4b0894cc8a479c3431ec56487ba398fb2207fd49560e5680cdf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ff71a41193e9d397c490f7a0133fdd9b11a0b5f6ea920e9ff48ff53766a1aaf"
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
