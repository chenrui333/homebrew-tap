class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "356bdc6569b54231ec3994c4d93cfc79fc02be76e6685968d846c6ddd451760f"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7414b02a05453a001e846b2c16885f39447c1542a189d747a105fa92f0c7958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7414b02a05453a001e846b2c16885f39447c1542a189d747a105fa92f0c7958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7414b02a05453a001e846b2c16885f39447c1542a189d747a105fa92f0c7958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7423518e29a10493416b030c66e201f072c92fe065baa6219e05de11b0ddd86a"
    sha256 cellar: :any,                 x86_64_linux:  "254c03f7f9d987eb5b0f476904594ba4d8a918e83ef4b39c6550c9bf44b1d709"
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
