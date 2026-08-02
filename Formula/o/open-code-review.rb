class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "22b1173424ee7401f0d200099fe45a87a0f02c7322dc93e0607578144ee26ba5"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d62a044e08639a7bf54fb2e229beff431eba5e632cbcda056077c616c6acee3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d62a044e08639a7bf54fb2e229beff431eba5e632cbcda056077c616c6acee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d62a044e08639a7bf54fb2e229beff431eba5e632cbcda056077c616c6acee3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe11113d9cb84650c3f8668e48054fcc632b0f957e6f0bc69258423b5ab2fec"
    sha256 cellar: :any,                 x86_64_linux:  "6145bbb90e7ef289e52ad66069d315c63e129df00b1ba24edb60288f9a70016c"
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
