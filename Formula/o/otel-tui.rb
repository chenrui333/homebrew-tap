class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "90ed095b21713704d1ab8002cb7141de382f3008036466b4c5bbde3a6dfbfbb5"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f34406b77b2190e2c94f6ce7d4250daa4e8f138eb41e65845f3dbaf32edff466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ecc73c7240411169a00377ef530cf1c51ab8ed9d7a927ee144bb0cbe965e5e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "075ec4191b31440e8e11aabd9814ddb5e5d2ad076a11abba9d55a0759c80d871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b2ea57c46c5e7a29ee5d8d188ff6a00af0f6a49dded2b63a15b31078762420a"
    sha256 cellar: :any,                 x86_64_linux:  "f8ccbed2e08befccc7fe21188553d050fc14ac8de0a477565753d6419e638374"
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
