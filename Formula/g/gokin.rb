class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.55.6.tar.gz"
  sha256 "4859331da336dd3d30395b69ca85051f852aa89007dfa8615583646be3950466"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93f10b8f6a235da8b85ca57cab88c796fd84adddefc52906ccf6e0ee5842dcf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93f10b8f6a235da8b85ca57cab88c796fd84adddefc52906ccf6e0ee5842dcf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f10b8f6a235da8b85ca57cab88c796fd84adddefc52906ccf6e0ee5842dcf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ba316ef1aec59e1dbb140d81bd3b107a4ac45728d09311ea561eafbd807d543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3489bceba8830c405fb8ca7a82c0066a14282b4851522042af628c8f9f25696f"
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
