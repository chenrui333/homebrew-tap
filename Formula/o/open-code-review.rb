class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "91229340a3f66da8e91d39465a1fb030afa3edb298d279f644527509ea45e044"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac443ddf43dfd9abf0594fbe5f11a828af94796cb9d5b1655b45df7b1abf84f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac443ddf43dfd9abf0594fbe5f11a828af94796cb9d5b1655b45df7b1abf84f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac443ddf43dfd9abf0594fbe5f11a828af94796cb9d5b1655b45df7b1abf84f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "874fa0d65e820a4152794fd6d9ab29a858129bfe2dd46e8e4d85314d7e54922b"
    sha256 cellar: :any,                 x86_64_linux:  "84a53e1b85d49c0807573092bc660139d726c5ea86ed7f7080908ae8e6d6df54"
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
