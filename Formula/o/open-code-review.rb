class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "c52c33ab088b4e86295fc4dd7b3bc2bba5ec9e78af0a8527a8da2eb8b5e3c2aa"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebfcf4639648e557b102e9296e70975d8d5f3452dc2b6a676bf77f7830fe2bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebfcf4639648e557b102e9296e70975d8d5f3452dc2b6a676bf77f7830fe2bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebfcf4639648e557b102e9296e70975d8d5f3452dc2b6a676bf77f7830fe2bfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dffc9c8e18cc7d5de33d058e2f41ce288b79dbf02dd17e9183072940074f39be"
    sha256 cellar: :any,                 x86_64_linux:  "ab573372236a28cd647e3b2becf53a7b5b644c59a98b7a4c558a3eac8bb304ef"
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
