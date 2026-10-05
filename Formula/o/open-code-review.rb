class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.11.tar.gz"
  sha256 "6f27af5bcac51437b726bc8b35bbc341b52b26a62b5bf2c74cd87a0e5ac19d65"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31f04bcc7cecefd356ecdcf01283cdfb4f96c501ba798b5eb626d7cfeeaee0ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31f04bcc7cecefd356ecdcf01283cdfb4f96c501ba798b5eb626d7cfeeaee0ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d2c6332b1ab42fe7bf36060d4d58d4af613936f50c76e723786a6403a95e7f7"
    sha256 cellar: :any,                 x86_64_linux:  "b9a8bd8a23c8c905397284918d915cf2d896ec7c04d4a01205d71b08d7217439"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
