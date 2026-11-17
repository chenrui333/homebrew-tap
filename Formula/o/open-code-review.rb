class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.11.tar.gz"
  sha256 "67122e5ed3e2f5cd1baaf45cadd9045527a4ca8cbe352cd6db907a18ae6afd44"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9665b56ba02b2e1c8ade45b099d80865335ecdbbbafa49e3f101904b81689441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9665b56ba02b2e1c8ade45b099d80865335ecdbbbafa49e3f101904b81689441"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c222606eaa6dfa569188d36228bb0d40baef87dab8989f2be3c272817ed59ad5"
    sha256 cellar: :any,                 x86_64_linux:  "88a9a77d25b6ccf1232cea42ec8701230554c756d46ff24e38d4ac13c4162891"
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
