class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "e0947e3059b73cd022f62f4ba902f5c81a84825b0900a2fc2ad2286ae4db22b1"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b950a403398e5c4cfc6c38a0bb3e210af19c892b80cb62a489fe32120bb1a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b950a403398e5c4cfc6c38a0bb3e210af19c892b80cb62a489fe32120bb1a24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b950a403398e5c4cfc6c38a0bb3e210af19c892b80cb62a489fe32120bb1a24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4e53016ec22f63d4f9c9d8e8d177ca581b6e74a3138e94d1c7347a0352f13a7"
    sha256 cellar: :any,                 x86_64_linux:  "9b50fe7e1ac4079a8fbda98ec5c0f146f8f48f91e9e894f6b49a7af108f441d9"
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
