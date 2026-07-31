class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "4c7214a2019b2760c06d1ff8edd05c697c24bdc7450a54aab9190cf1d3dbe2d1"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e62b682cc8829079301e5f6c7b13b4701eaa518d51b195d9513acc1871592735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e62b682cc8829079301e5f6c7b13b4701eaa518d51b195d9513acc1871592735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62b682cc8829079301e5f6c7b13b4701eaa518d51b195d9513acc1871592735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b4b4a68bd045a17fc3070fd479c44e8212bccb121f29430640eefc0d3004a2"
    sha256 cellar: :any,                 x86_64_linux:  "5244130e23a117dd748ba366693cb5432a6d7b4ffb17dee3352c7f83d8fba950"
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
