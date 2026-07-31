class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "efe57b9b6db7367e3bc8b8f3ac5d5cfa983a7ebcb59a7691fbd29f2eafac4467"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8596f322db27b68d849c429df5ab11fa8f4b3da22f371cd0a62f26b37eeb31c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8596f322db27b68d849c429df5ab11fa8f4b3da22f371cd0a62f26b37eeb31c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8596f322db27b68d849c429df5ab11fa8f4b3da22f371cd0a62f26b37eeb31c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b2030c84d78c7c32fe7540b2f3615ef9f6922e00610578050ea941c20591df6"
    sha256 cellar: :any,                 x86_64_linux:  "5aafe70b93c1a89d203d9205bfbe157a7d1748cf2e481a6a138ecdf3ef2a641b"
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
