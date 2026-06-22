class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "f022c4c91f5c45f2498282c36ba3b1de27931b9a57f85dd38d6a59cf1fcfecec"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d00410ff6658f76474124887999a2f09add5759e6fb6d38a97d3effb7a1a64ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d00410ff6658f76474124887999a2f09add5759e6fb6d38a97d3effb7a1a64ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d00410ff6658f76474124887999a2f09add5759e6fb6d38a97d3effb7a1a64ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c857bd0f8003f71cd931e0158d42ed8ad7489d45dc4437b63ad9bf87ec3c715b"
    sha256 cellar: :any,                 x86_64_linux:  "630203e37551072edecebae8a8cc0b371a8da51d467f6129d2117324376d7757"
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
