class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "2c4249c3551dae233d4c70274b785ce0b74bbcc78e5b56d0a6ef65b7f8501dcf"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e64c6c5aacadc8fbbb8e453dfc6b76bb64a165a14e0e5a253cb863b2f54bfbd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e64c6c5aacadc8fbbb8e453dfc6b76bb64a165a14e0e5a253cb863b2f54bfbd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cace99edc1698ca755229afc9a2b94b41c99103ab316edfe0669f0db8dd67133"
    sha256 cellar: :any,                 x86_64_linux:  "a96d5cd7ff59f09fc6702ac3423620490b0432ae5fd5c63727d2b50b6a612327"
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
