class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "0710bb01ad93dc59cc83f4357d8c02b22375a47c4de2093c643b66fc03a34811"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "642931d8f9aabc892c9cacd86ac720ef499c81bdce4807017f38e8c005579851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642931d8f9aabc892c9cacd86ac720ef499c81bdce4807017f38e8c005579851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5b0a4ef5d2ab790b41c430db9498b5720a1923903f4d39a7aba8178cb1c197"
    sha256 cellar: :any,                 x86_64_linux:  "32480893361e1421aed96fc7ac304237b031427e651dba47b331e76f8ddc033a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
