class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "0710bb01ad93dc59cc83f4357d8c02b22375a47c4de2093c643b66fc03a34811"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b705cf8ff07621cf7c25baed69c8a127f6e77d2e6a8d8acdce673a559f6c51e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b705cf8ff07621cf7c25baed69c8a127f6e77d2e6a8d8acdce673a559f6c51e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1616ab9eda74aafb4c00b06ef8d0f57f3cd8933d2c949e5eccd0c9150a36e26f"
    sha256 cellar: :any,                 x86_64_linux:  "a7e9f6c871a80cb3d2ab3ae2f167ff244c7ce91ec04b417c80add3035ff37472"
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
