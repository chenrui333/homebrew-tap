class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "5eea404758f8972b420526650f5d32f06668090ae5a957570f0c13befaf3e182"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7fe936b528811c564a2a90c902bc6f5fbb1837ca4ccf9b1e17781a40c6b4741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7fe936b528811c564a2a90c902bc6f5fbb1837ca4ccf9b1e17781a40c6b4741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7fe936b528811c564a2a90c902bc6f5fbb1837ca4ccf9b1e17781a40c6b4741"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce48ced019273e91d4f0a3ed64ed09bd5f3357b4b820b89473f3c912ea2bc880"
    sha256 cellar: :any,                 x86_64_linux:  "367fcb008d216a593f6041d1b9b06b15448059ec546bb43f7e95da145db34e51"
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
