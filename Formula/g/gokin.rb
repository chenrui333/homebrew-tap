class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.86.9.tar.gz"
  sha256 "42038dd8d22502ec1938ccb2a76ad9adb537b8458d052ee43dccea97fec0e552"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a78b3be99276aeddefc8eb38f017a34ddc1379142f56355ec70851d72e920add"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a78b3be99276aeddefc8eb38f017a34ddc1379142f56355ec70851d72e920add"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a78b3be99276aeddefc8eb38f017a34ddc1379142f56355ec70851d72e920add"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21fa4ffd7c1741eedae37cdf084921d0355301e6355b1ec1e90117e937afeeec"
    sha256 cellar: :any,                 x86_64_linux:  "801726638f3f8a61c9153a066b52c4f01a23bacf0263b2e8e59dc5d119915201"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
