class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "0f89e3e7c29a788eca37688599cd3c8f57e4f1be811feb2738fd7f1d2b987b52"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8879b1386ba40ed1ac850484b2004b80abb0100f4f6430fc893d341f4c458ee3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8879b1386ba40ed1ac850484b2004b80abb0100f4f6430fc893d341f4c458ee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8879b1386ba40ed1ac850484b2004b80abb0100f4f6430fc893d341f4c458ee3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8a38c35794cbccc231aa67070663517f2ebb6f81f6c868d1e7954e8bfcc4270"
    sha256 cellar: :any,                 x86_64_linux:  "b276b2ebd9a7c111ebbd4a4fc6bff8aaa0f953b8b2096916245a96d79e1659f9"
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
