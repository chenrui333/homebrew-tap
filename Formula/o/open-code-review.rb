class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "ef44069f812102545b15404b5dc40a2a8c9c13508ff4ad020e1d4a69c851465c"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce4dba9e945472eb177263b6c5de8dfcdc01358fc19125f0a1f3d3e16667de43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce4dba9e945472eb177263b6c5de8dfcdc01358fc19125f0a1f3d3e16667de43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce4dba9e945472eb177263b6c5de8dfcdc01358fc19125f0a1f3d3e16667de43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1921c409920f384ca39067d8fe58e1b22ff9545e5ad3bef78f19db9be683a84"
    sha256 cellar: :any,                 x86_64_linux:  "34d4d50c378fbbf6f5d8d0fab9f45b2c2848dea3aa9dd97f34bc9fa14577a316"
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
