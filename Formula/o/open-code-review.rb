class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "79d85050968f6932c327e9a808c7a6a508d7504583c2677b45e6b74ae881a0f7"
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
