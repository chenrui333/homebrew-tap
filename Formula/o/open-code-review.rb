class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "d756515d12aa0faa7f08270282d077d888f690c986bc131e8a646454c4d6678e"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41289d96b693fe944af9badea1f24aeddb44da85467bb2f818272e0c9295c85c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41289d96b693fe944af9badea1f24aeddb44da85467bb2f818272e0c9295c85c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41289d96b693fe944af9badea1f24aeddb44da85467bb2f818272e0c9295c85c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af967ce9da4c5b9baeb491d497064f2ffd9131429bcecea268f99b1410f40f62"
    sha256 cellar: :any,                 x86_64_linux:  "131d0a615cfbe136b201d904176f6b7be2ec0b5dcb44624667b13db0fcbe8d63"
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
