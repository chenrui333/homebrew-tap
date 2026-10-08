class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.13.tar.gz"
  sha256 "559576cb9eebba315e3c26ff03eeadb741340d22b4ba2463ed5bae796563a12b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0e2ab5eb468624593100b4409d23f4cc50c780623f495a80b1f046bb7fe6cf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0e2ab5eb468624593100b4409d23f4cc50c780623f495a80b1f046bb7fe6cf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e22a19a3f711dcc7d34e631f357b69fd7c38895c5bf61f1a1e52d26968694f73"
    sha256 cellar: :any,                 x86_64_linux:  "724453af710e04b9bb8c9ec438502d02a0a4b310059d4128d17c859c9ae0fded"
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
