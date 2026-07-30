class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "2d12e62e3109eefadc266705a8352e01510d640bb89a892330b1e01dae07139f"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a64926ffcea140adf03e8b7b3c1257b0e925281e24bcc1a74d80abd37469e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a64926ffcea140adf03e8b7b3c1257b0e925281e24bcc1a74d80abd37469e87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a64926ffcea140adf03e8b7b3c1257b0e925281e24bcc1a74d80abd37469e87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d17f9196a1033d0709a941924d56163303507ad016e6940b6c645daa8dce6d4"
    sha256 cellar: :any,                 x86_64_linux:  "f50464d1a873a538dfd2a9a84d71285c080ba5fb35a4e7b6eeaa97752b4f6de5"
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
