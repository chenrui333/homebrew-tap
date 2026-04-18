class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "8b2297699d8a2414761f39a1bc6a736bdf3f5a2d9ff44f80e9a85f80f4e6a309"
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
