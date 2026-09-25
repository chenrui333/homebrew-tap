class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.9.tar.gz"
  sha256 "29ca53007ecb9aaa350a95975f620f672df97ac01599246d10b3549a9652ebc1"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80714704d625c11920432f0ede6c122316add06dd4fb36809f69558175603594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80714704d625c11920432f0ede6c122316add06dd4fb36809f69558175603594"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61fb6769f83c75843cab212ec2acc813524dd35c09cb5630c069ace4d999edf2"
    sha256 cellar: :any,                 x86_64_linux:  "817bb16c9c8ffe94ab50fa00fef607ea47fbd210689bf98589734928b5b3b3b8"
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
