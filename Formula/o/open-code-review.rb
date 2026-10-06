class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.12.11.tar.gz"
  sha256 "6f27af5bcac51437b726bc8b35bbc341b52b26a62b5bf2c74cd87a0e5ac19d65"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ebfc94d94ef5058b2122310300fd52d9b42e1ef275d28b355b75e80b8efd302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ebfc94d94ef5058b2122310300fd52d9b42e1ef275d28b355b75e80b8efd302"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d931293d72e5e10a951d55c3cfc9517bc2984709c1a6a32486a9fa50e7521f00"
    sha256 cellar: :any,                 x86_64_linux:  "aacffd17e379db671ace9cbd6e14a768aa96e979de81bf1c4a120e4806f3a4f1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
