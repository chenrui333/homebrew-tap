class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.10.tar.gz"
  sha256 "e6a69f15e74c13b3ef455b2df4e51d69d88057f07ecf2d64f20d4a02673a1756"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbb446f39d5451227f79c48c4edc56ad7367a28fcf59c1ad7163528db7b66010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb446f39d5451227f79c48c4edc56ad7367a28fcf59c1ad7163528db7b66010"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb446f39d5451227f79c48c4edc56ad7367a28fcf59c1ad7163528db7b66010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaf3cb53a9fe0e750ee91862a0bcff1782d255df5c90f97aafea249ac7aae136"
    sha256 cellar: :any,                 x86_64_linux:  "9ddf4dd26250622e409a67c9dfcb1a59cecb48e63ce5791bdb3a98c57eabde78"
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
