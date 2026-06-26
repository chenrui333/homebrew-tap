class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "3e1d9a1c7a2d25214563a0c034eef781cfb308418887c1e0e27fcc8aaaf554e2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2dffdfac6b35ef89ac4ae00d113af06600c03ec286debfb034529d9c3a289a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2dffdfac6b35ef89ac4ae00d113af06600c03ec286debfb034529d9c3a289a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2dffdfac6b35ef89ac4ae00d113af06600c03ec286debfb034529d9c3a289a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d03d9fdf445d40842f2f18a0b3a3aa09341a8374971d4b774a38f0131b7f028a"
    sha256 cellar: :any,                 x86_64_linux:  "534bd54d81012238482a0f6a93abd8c8c6755449195ad7c375784f5d035e4ab4"
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
