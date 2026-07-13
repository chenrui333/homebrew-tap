class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "a83b4af5c31023932d797e7137841458e0b160ebf9851123ea365f6a892d6fd3"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a693c2e326bdecdcce7e45e2494de9ffd07324653b8afb5a21968510229b0ffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a693c2e326bdecdcce7e45e2494de9ffd07324653b8afb5a21968510229b0ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a693c2e326bdecdcce7e45e2494de9ffd07324653b8afb5a21968510229b0ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54d97082f5c362769f8c89d49affe274cae99b035c08aa04d04023bbe258faf3"
    sha256 cellar: :any,                 x86_64_linux:  "7347b70726fcb2dea71c82fec691615178f99048cb39fea0ed40420b5c2a4faf"
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
