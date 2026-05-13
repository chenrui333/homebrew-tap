class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "af1a7863b80edf2c697050f3620acc6d2079972be91ea4b48aef6d7ed9a1c016"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f267835a9717fd83de30d11525724c8c0cd76c5119cb828c12e1d8df492b46c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c27f3b7617da9f3384740ed0cd6dede046dde7a9c2e322843a3f70bf75c3696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e7224e23f7962b3146303e36c8a866d4c14372dfb2ce79633dcd7f914b0149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7434740dcdc3be3b321a374d2ee5128e8da4b3a78d4d093cdf5b5a618297d3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eab4f1a27b0c33e2acd3bac3ac591a804ea16c9bc34f7634dc8d1b805b77bee"
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
