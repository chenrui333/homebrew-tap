class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "ef44069f812102545b15404b5dc40a2a8c9c13508ff4ad020e1d4a69c851465c"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a70a771760ab4bbd6148712f57a8990bb82c2d995375ae7420a70b5d2e39ebb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a70a771760ab4bbd6148712f57a8990bb82c2d995375ae7420a70b5d2e39ebb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a70a771760ab4bbd6148712f57a8990bb82c2d995375ae7420a70b5d2e39ebb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f32db93a95ebc997e7314ef1c2c85be9ee6843dd6deeea5acd619ee476f6b00"
    sha256 cellar: :any,                 x86_64_linux:  "0db9261b5b08bd0e7616013805283bd00d3656cff7eebbc886b85b240b1747e1"
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
