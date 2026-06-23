class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "4b1f624ba64594cd80d9a6e64861ab77a6fbf343165aa46e726585f1351e55da"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68307c433764866536ef13cdd1b0b57ddcc3cf36423d456558d80a0c76b06ea9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68307c433764866536ef13cdd1b0b57ddcc3cf36423d456558d80a0c76b06ea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68307c433764866536ef13cdd1b0b57ddcc3cf36423d456558d80a0c76b06ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0f46b16aa19576909b5acf807929971ff7e21b2dd1412013019420c9ac9bd57"
    sha256 cellar: :any,                 x86_64_linux:  "4868d9741e6ee9f17d469d41cb7e0e91533c8d3bbf1b1ecc882595af8c3fb9a3"
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
