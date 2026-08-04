class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "a2574d5bf71188c8d3b6ea240163253747be705d7775db99980a672285b6abee"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9520b0ac37baff162d6fc6173a76bbedc3d6df392f030dbe5b6505a988529092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9520b0ac37baff162d6fc6173a76bbedc3d6df392f030dbe5b6505a988529092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9520b0ac37baff162d6fc6173a76bbedc3d6df392f030dbe5b6505a988529092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfd7a167769ae99b9c916f66252d2ac6f8b000f97921fca4ff3e7984312e2283"
    sha256 cellar: :any,                 x86_64_linux:  "dc8a1dc7328591eda908cd4ab9e2e298f13bd2d194567252ff7805552732c869"
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
