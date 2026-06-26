class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "174c89b08940a6a033e6ae900d4dd84880b75a25b8631fca9f94825e65fb0732"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed38305b666d9f5f373e171eb933c268f7fc0fd4c389cabe22f85b4774220e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed38305b666d9f5f373e171eb933c268f7fc0fd4c389cabe22f85b4774220e73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed38305b666d9f5f373e171eb933c268f7fc0fd4c389cabe22f85b4774220e73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9af83b4a3d4069cac895177328e9d1a41a61d5eb5ec824c035a47cb867974d9d"
    sha256 cellar: :any,                 x86_64_linux:  "1cda08d0aa68cb97d058ab047cd9136419982266c9e17942c2dd8a95961f9678"
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
