class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "6152a3a57c2c8769c6bdbbcc5b7219a97742ea380aef2c1b9e777f482f677154"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce2a76a13cc18e2059e16863d5153e56fb3d4ea44df5d68cc74cb19ef9a15033"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce2a76a13cc18e2059e16863d5153e56fb3d4ea44df5d68cc74cb19ef9a15033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1bcc9992070cb55f5283328df5536c490967dd8259eb5e8d565b8b51a42e21c"
    sha256 cellar: :any,                 x86_64_linux:  "d9688c7ffd5946a908d42f49021e7b70f2e06dbb04455b63b0543db9ed50544b"
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
