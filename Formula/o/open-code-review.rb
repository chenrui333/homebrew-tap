class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "04e7faf368911a75f45ed8f3fb431346d86ef52da74927d7f6906d89ca081f31"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "203d4be1ef6f423131554a7514d377f45716d9f15fa30aad4b69e097f39f2f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203d4be1ef6f423131554a7514d377f45716d9f15fa30aad4b69e097f39f2f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203d4be1ef6f423131554a7514d377f45716d9f15fa30aad4b69e097f39f2f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13720651142e16f3b31509ceb98925cd18fb4e05eb4ac39558883a81e443798f"
    sha256 cellar: :any,                 x86_64_linux:  "7d9b31a210283e5ad9bf280e735b70bd8e897b75faa04385bd4a47de71ec583a"
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
