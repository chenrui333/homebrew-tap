class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "9be8741c0c7c73a807c3e01a172f00226598c6246c597add462365a528cc2254"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "f8b55e28f622042484de492d6e67b67c289dd6fb4798ae9afc3fd8783638289f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ea2daa8b0433d42025e03d50e4fecafe2107a0f835638430cecd6b951631839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ea2daa8b0433d42025e03d50e4fecafe2107a0f835638430cecd6b951631839"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bacfaecd4f809e581bba094bb907f4192c436f80af1f32587a91250ee21d6b20"
    sha256 cellar: :any,                 x86_64_linux:  "86b38ca6c715c411cb5c3110f596293791c61ba164fcea81403eda39bf3e6331"
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
