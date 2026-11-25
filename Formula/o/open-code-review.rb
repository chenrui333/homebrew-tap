class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "01f9f70263825df1b62713d428c8de8d2c3a60ff49e5499b076c4aaaeb4efe22"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4d94c4f0dc042d58c94f9b595483306a1fa81a886490d0988b18e9b5d280d4c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b4306f474e8ae8f82fc8e4d8c563fe4e7e4e8b10b0bd972318469eefccc705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7b4306f474e8ae8f82fc8e4d8c563fe4e7e4e8b10b0bd972318469eefccc705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1935e319c483005b684588808fd2b2999ac997fc2e66667e8ec7968f010dc1a"
    sha256 cellar: :any,                 x86_64_linux:  "8fe98d3aa62ac154d67f11fbf81456f5d6a8165b886c35b86834818a945d8c62"
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
