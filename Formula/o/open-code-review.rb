class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "cf948a888db50936492995e9da72320457ba0aad2add9180f2635930051c7a52"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "812be64d1509fdbbb2c915aab1c06d6e5991ad2e8f3e17932be4edc6be6523eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "812be64d1509fdbbb2c915aab1c06d6e5991ad2e8f3e17932be4edc6be6523eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "812be64d1509fdbbb2c915aab1c06d6e5991ad2e8f3e17932be4edc6be6523eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1213f4710bb804f1918df19de9f55fa2056690dda0ec8584da884f1567de307e"
    sha256 cellar: :any,                 x86_64_linux:  "21a6be1748ef3923de31defcbf74bf92fe927c0d69949c2b058755f46cbf5033"
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
