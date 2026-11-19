class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.13.tar.gz"
  sha256 "15cd57954ea498d20c4384fff5d35b52b4e2a858205cfd52fa37f319b5219865"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7ff429136953e0451aab3c68affe635658ae8211ab42760f9a1fb5f7a882765"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ff429136953e0451aab3c68affe635658ae8211ab42760f9a1fb5f7a882765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17d88b5434baa9258f1cbc8ca4e0fa43dd4790feb10c2163fa4c68b03e91b6b9"
    sha256 cellar: :any,                 x86_64_linux:  "d4d3098ab45727800232f8173c00905328844d5a183c279ee0e3a693f7c677c9"
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
