class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "f67ea28a3ada6055435d4bdf41f2355d4df7a2a3c393d2e36d9e075e15223777"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56f098c715267fcb4d55259839ecaa5f8ce324d6e78e2534f140e4c770bf7e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f098c715267fcb4d55259839ecaa5f8ce324d6e78e2534f140e4c770bf7e73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9df908c7d8d9d46dd3a4180bea0a263c3f8cef91e7e753f493d03aef05cb7ac"
    sha256 cellar: :any,                 x86_64_linux:  "763e7e54070b9740851df008d577d8669e3c0feb1bfe106447258f760cc8f75a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"
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
