class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.10.tar.gz"
  sha256 "e6a69f15e74c13b3ef455b2df4e51d69d88057f07ecf2d64f20d4a02673a1756"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90bad7201b1dc4f9be2a7c929667da7f2bbf7391d2327a9b8a75251a0e11ddb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90bad7201b1dc4f9be2a7c929667da7f2bbf7391d2327a9b8a75251a0e11ddb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90bad7201b1dc4f9be2a7c929667da7f2bbf7391d2327a9b8a75251a0e11ddb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd073153680cfaacda7ff77b82548e0049cdfd9fe3f13e9829e46db53f709f2"
    sha256 cellar: :any,                 x86_64_linux:  "f7a1772483cd297a7f1283dc6b448b1f801314a0b2dbff55897d0df50d405934"
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
