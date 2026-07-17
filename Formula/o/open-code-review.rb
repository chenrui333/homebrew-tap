class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "01685b5fb4da6aef14a37060cb0dc84425327427963c1fe2582f5a47f4d15983"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fffbbd543f417b1bf365fcb590631d80c9d6930f6130798dcd5802f7316b0ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fffbbd543f417b1bf365fcb590631d80c9d6930f6130798dcd5802f7316b0ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fffbbd543f417b1bf365fcb590631d80c9d6930f6130798dcd5802f7316b0ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22d179ed38ae0633c334702b2e19265f02490a6660fab8f381be4f2b7abdc8ee"
    sha256 cellar: :any,                 x86_64_linux:  "1db4bb397d5b7baf5dce7ca1619af721dd77f2f51620b7063bea760c8ac1ec88"
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
