class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "84e0572de8eab9fd977fe965316424e93f9f5744d415e7047b8fc50996792a81"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8a74577f214f9cad2a524da3573ab9d07f5b355f9fc76e2e33929f7fa221e86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8a74577f214f9cad2a524da3573ab9d07f5b355f9fc76e2e33929f7fa221e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8a74577f214f9cad2a524da3573ab9d07f5b355f9fc76e2e33929f7fa221e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe6acae1aaa6fd3482853a0110d2bd2a4a21f5bc3fa5fedb7bfc49d180646544"
    sha256 cellar: :any,                 x86_64_linux:  "61fa6000ef2401adff4575fd412666ad287a0c04f718ee4951d76d8c4a3783bb"
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
