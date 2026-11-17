class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.11.tar.gz"
  sha256 "67122e5ed3e2f5cd1baaf45cadd9045527a4ca8cbe352cd6db907a18ae6afd44"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e363fbbfe8f191034d341b9e81f8f19bf591d68b6e1c7dd103f7022a0595d3a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e363fbbfe8f191034d341b9e81f8f19bf591d68b6e1c7dd103f7022a0595d3a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2241534dda1bff87d0bbaff9c9814dd596b8f59331e84157ba0f392de467240e"
    sha256 cellar: :any,                 x86_64_linux:  "f5a9bfc7368cd77d0ebc35b42e4838d8021e20c7729afca2fb3b077240528af6"
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
