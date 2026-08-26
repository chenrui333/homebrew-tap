class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "975c7cfb099cc824bc6000d009d6535580c81db79d6e395a2a40f17f4fdf142b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd023caf7a9fdd7d7563df951245351c09af88b3ce9c29d87dc524fa2a9f82d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd023caf7a9fdd7d7563df951245351c09af88b3ce9c29d87dc524fa2a9f82d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd023caf7a9fdd7d7563df951245351c09af88b3ce9c29d87dc524fa2a9f82d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f50fdf2e98cd9d82105fc6b6efd85c4412a49b164db55452c2058aeb2b4b6fa7"
    sha256 cellar: :any,                 x86_64_linux:  "afc79cddd8378f2f42db0d16103331479a80eb113fd87f059a5c8ee77b59c374"
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
