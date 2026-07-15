class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "4baf2f3b5ed5089f631f951956acec27a8db45619f13fc41f7ce585d37cd74c0"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "727922a96e4138dff1d9ce5f554c95a65cc4e8dcc1b43c7f688c79890114fb96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "727922a96e4138dff1d9ce5f554c95a65cc4e8dcc1b43c7f688c79890114fb96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "727922a96e4138dff1d9ce5f554c95a65cc4e8dcc1b43c7f688c79890114fb96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da96acf7384ba765337ca690d34ca1a46a73db64ddb66f8be88fc07263d1411c"
    sha256 cellar: :any,                 x86_64_linux:  "71ba4fe0c494ec31812441cf0f82aa335a483d7fa51da4acfffa6183d5459dc8"
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
