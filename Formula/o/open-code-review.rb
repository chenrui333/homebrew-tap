class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "b194782a69c84fd42fe174fe82034a2806c2ac4c58924ef19d6e60bd29672d06"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10473ef5c2137d366bb60c5427b2297a04a0807c9e57a796959237a7005da18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10473ef5c2137d366bb60c5427b2297a04a0807c9e57a796959237a7005da18a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10473ef5c2137d366bb60c5427b2297a04a0807c9e57a796959237a7005da18a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "277de205df166037655c66b691861f5fd496a5efcb25065babf120db03b8bee8"
    sha256 cellar: :any,                 x86_64_linux:  "4d3ffc92a633c0758f323aa4f621443261fddd95b5633c43e26840d0abc0351a"
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
