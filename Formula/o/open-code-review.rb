class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "b194782a69c84fd42fe174fe82034a2806c2ac4c58924ef19d6e60bd29672d06"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3faf6838db00a57c52d183d4c6b4ce7b8cc4bed84da4383645df46feab2327e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3faf6838db00a57c52d183d4c6b4ce7b8cc4bed84da4383645df46feab2327e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3faf6838db00a57c52d183d4c6b4ce7b8cc4bed84da4383645df46feab2327e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd0e72c4f16f4a302a6b84a678a37d8340a63f228d97d9902dbc4e7776098e2a"
    sha256 cellar: :any,                 x86_64_linux:  "91d367ed56560fa429bb7a555ca4433b21588ec7f642070b174251852c628f1f"
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
