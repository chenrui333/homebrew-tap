class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.13.tar.gz"
  sha256 "559576cb9eebba315e3c26ff03eeadb741340d22b4ba2463ed5bae796563a12b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f0dcff3371a2fbc3349d1c3f206e1716565bf92f7a96f5a5b8d569a0452e4c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f0dcff3371a2fbc3349d1c3f206e1716565bf92f7a96f5a5b8d569a0452e4c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "018c4aa0d055c76988890be3c3f1ef06839a6e60dad36cccda61ce3425eff86e"
    sha256 cellar: :any,                 x86_64_linux:  "99bea812bfa2c14617fd3380698ed877d789631c6cf96c6463cbbdcd57519896"
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
