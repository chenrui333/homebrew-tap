class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.13.tar.gz"
  sha256 "15cd57954ea498d20c4384fff5d35b52b4e2a858205cfd52fa37f319b5219865"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "773c22d9b955b91536b890872487f227295d6bfdfea12fc2528638a4aeee3964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "773c22d9b955b91536b890872487f227295d6bfdfea12fc2528638a4aeee3964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "982e8cc6d528290e48c0358d8974d2061a1317dab733542a0239e38755af5887"
    sha256 cellar: :any,                 x86_64_linux:  "68ab40d967157e1ab92885cd3e52ef938abaaa1f48684824d955ac09853bfd2f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"
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
