class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.17.tar.gz"
  sha256 "29756a76a8eeba71962ccd68e77ad3051767cca3004841f01fc7d381297823e8"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1377a8bffb8b6cb62827399ae4f0909a08d7b012f15222db70092ca8714420ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1377a8bffb8b6cb62827399ae4f0909a08d7b012f15222db70092ca8714420ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1377a8bffb8b6cb62827399ae4f0909a08d7b012f15222db70092ca8714420ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7d58e16785f66d95bba5b0a8168f0209e4cd645c74b8f015796ca718196f865"
    sha256 cellar: :any,                 x86_64_linux:  "1988bca6100d65dd3142024f3e3effd9a60538d0881709ce0ae1bc6b57c242ae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"ocr", ldflags:), "./cmd/opencodereview"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocr --version")

    system "git", "init"
    (testpath/"Foo.java").write "class Foo {}\n"
    output = shell_output("#{bin}/ocr rules check #{testpath}/Foo.java")
    assert_match "Source: System built-in", output
    assert_match "Pattern: **/*.java", output
  end
end
