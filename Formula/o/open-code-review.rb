class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.17.tar.gz"
  sha256 "29756a76a8eeba71962ccd68e77ad3051767cca3004841f01fc7d381297823e8"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb00d327f929c844ae0eafbc4e87144a769c7edeeb15daf9b3659c88236fedf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb00d327f929c844ae0eafbc4e87144a769c7edeeb15daf9b3659c88236fedf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb00d327f929c844ae0eafbc4e87144a769c7edeeb15daf9b3659c88236fedf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ac82512b226a43976fc7c5e4678891d6e46a644c9ed809a14f20daf72751282"
    sha256 cellar: :any,                 x86_64_linux:  "d91917387551d26cb751d3ebe44e52b4eddbf7ba7e870bb3fa3dc4d16241f48d"
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
