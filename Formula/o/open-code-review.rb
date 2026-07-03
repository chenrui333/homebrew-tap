class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "7482cf68b9883383e295681a8c187fff2102f0c9c2e9012053a34427176bf31a"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31779b0f2d483fcdbae1f30ca19353e00a77fe3a063a2d4ca04f6100d4b29b9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31779b0f2d483fcdbae1f30ca19353e00a77fe3a063a2d4ca04f6100d4b29b9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31779b0f2d483fcdbae1f30ca19353e00a77fe3a063a2d4ca04f6100d4b29b9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b5dfb508097affeef30f6e56b70dfa059e9763c4c768393413ed755114ce4c8"
    sha256 cellar: :any,                 x86_64_linux:  "1c7d3c2d4278df07aac32e2c6e45bce1a1a9247196248fdc7b391f34f662a7c3"
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
