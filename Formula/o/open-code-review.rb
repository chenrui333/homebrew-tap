class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.11.tar.gz"
  sha256 "6f27af5bcac51437b726bc8b35bbc341b52b26a62b5bf2c74cd87a0e5ac19d65"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ac939dd3cad3f65378436bd40081965d8aa594da835bf929c4d1046ce49ea84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac939dd3cad3f65378436bd40081965d8aa594da835bf929c4d1046ce49ea84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e221ede08c9b70bf6a408f3412cdac691d0b3f9f2a3aa85fe1df5a79646a3619"
    sha256 cellar: :any,                 x86_64_linux:  "35481298154c2f1801dce92c5fc85ffa0752ce30c0ceb52c0903872ea285ab33"
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
