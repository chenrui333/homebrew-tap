class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "6ee0f6d7daba0eb053d4f863f6868c1402d25d0ef781b157afe3853c7fd0c0e8"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beb46f043ee38182690b5e56cfae1b11d2afad067eee500771db083742163bca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67c0cebf5b4f9b5ed55c5aaaa7de69de2fbcee8b79b8a3086fd6ef8e60a1f7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e28debe4101f3fa3eacc9a6ba3a46e3cd7624eace9bd4656e2130e6698823b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "805707c6d2ff001c2b9f705f3a00edbb9975650d30f8ccba4c4fcbd2bca1d7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "166175a3751055295b159f4d8cbfa1939be1fac167b3ec3ff144ccb586e353eb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    ENV["GOWORK"] = "off"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otel-tui --version")
  end
end
