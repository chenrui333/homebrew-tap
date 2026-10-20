class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "b3705f5933152bcf1c38ca6c1ee42c518c6d6a3c282a2841b98bdb254c591f4b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b57c4a28ffd78d58d61ab7085b1baf16416bfa078890536f5412b4a6c81fc7d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b57c4a28ffd78d58d61ab7085b1baf16416bfa078890536f5412b4a6c81fc7d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83deef74caed36c998b7ea7ac1b83f20a516349b8cf6dac55f833c731c2fe54"
    sha256 cellar: :any,                 x86_64_linux:  "aa30a7c878124a86446d16525c6ad9d9c20c7af3470256820509d0e755babd4e"
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
