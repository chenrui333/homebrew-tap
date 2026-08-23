class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "84e0572de8eab9fd977fe965316424e93f9f5744d415e7047b8fc50996792a81"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c1155ae64a6381971784eb1bba74c078f85facb8a6f2630af71861ee8cc18d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c1155ae64a6381971784eb1bba74c078f85facb8a6f2630af71861ee8cc18d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c1155ae64a6381971784eb1bba74c078f85facb8a6f2630af71861ee8cc18d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e029db1f913353b246a9363bd49a01f506de04ceb05fa314002a1ea2d66359db"
    sha256 cellar: :any,                 x86_64_linux:  "450d038a8fa4de299f3aacf6f0bfbb3cea9e024901e501d9798d8cde0e42d9c6"
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
