class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.47.tar.gz"
  sha256 "ba41faab8bc87914d851d97146d1cec49ffd7a8361898dc387705c4af0283c87"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d2dcfc81187650d50c9c55fa379dbe2d60fe79af1d0cafef73e8740059356db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2dcfc81187650d50c9c55fa379dbe2d60fe79af1d0cafef73e8740059356db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2dcfc81187650d50c9c55fa379dbe2d60fe79af1d0cafef73e8740059356db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d6048d7e8acf7d8d6f95f7845e69d8f496e2b573991d055eed4d1598ade542"
    sha256 cellar: :any,                 x86_64_linux:  "1cdd7a37793d3a4bdb9c873789ccb91134b759fd1164596ce93bd1996e01feed"
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
