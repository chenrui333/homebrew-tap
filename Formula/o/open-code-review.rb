class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "437186105b826a6a6d64496ede0c16b7ab89ffdee41597a572d1eb46022ad6f5"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "307c9ac6bab55b526cf18f9d1b993c42d06456793d53d00c9b3504a8fc8c3eb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "307c9ac6bab55b526cf18f9d1b993c42d06456793d53d00c9b3504a8fc8c3eb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "307c9ac6bab55b526cf18f9d1b993c42d06456793d53d00c9b3504a8fc8c3eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981a299a210a3d074538ac62ab47cacac8208193f0b66d55b33794248d767c54"
    sha256 cellar: :any,                 x86_64_linux:  "e6beb1abf3b01b37f154e5803670d0d7a73de428f659aced1e9ca4832614a383"
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
