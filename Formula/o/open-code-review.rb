class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "c237921b952ff2f6861672a700d3e64b65429add9585121eb02f079e455ed1d2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2aeaec8013498a6b91c483357f45f7d5d2b075b4b56b9ca37269ec027d9bf66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2aeaec8013498a6b91c483357f45f7d5d2b075b4b56b9ca37269ec027d9bf66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2aeaec8013498a6b91c483357f45f7d5d2b075b4b56b9ca37269ec027d9bf66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607ea0e0bd1ebf658ae6b82a746bdba7f98d61889b20e9ef7ac1a81cf91e98b3"
    sha256 cellar: :any,                 x86_64_linux:  "72b85f290cd14ca7242c0a1e48788fcd34ae7958b8908f7fcb98af5b5f5b5225"
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
