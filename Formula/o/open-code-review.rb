class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "9f834e916b5038bdbebba4dfd18283e2ead1648d305c894aa87520ccb8e875b2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "541c0f255e51761a371c9f4ddfa677cd656a8233d682045eeace991af911637e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541c0f255e51761a371c9f4ddfa677cd656a8233d682045eeace991af911637e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541c0f255e51761a371c9f4ddfa677cd656a8233d682045eeace991af911637e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e40fc7c660122010e32fc6507202c3567d8589649802289a44e16332d8d407"
    sha256 cellar: :any,                 x86_64_linux:  "09eb0a08211b76bd69fa462041ab57e6c9c6ebf89ce90db11b789452dc5404eb"
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
