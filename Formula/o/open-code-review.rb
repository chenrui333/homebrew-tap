class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "b3705f5933152bcf1c38ca6c1ee42c518c6d6a3c282a2841b98bdb254c591f4b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "711b4aebd10331d9812e1ba3efb16630acf05ec86e2935bb09c516895de33be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "711b4aebd10331d9812e1ba3efb16630acf05ec86e2935bb09c516895de33be9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5330a31fcc63986fe00bf470f988f43362d3f9c1d54a4e7917661689ce43717"
    sha256 cellar: :any,                 x86_64_linux:  "c37a0d03159ff080e67fecaaf32a42b555fbb4bde2092ad3f8da391ff600b137"
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
