class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "37bf8d655ee6dac4706c989424fc77ce239f4b45b115523fe3e6db73f10a1ce1"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9a50cb556fa9f26f3fb291aaa87a99a728980fed8d055427a5203781188b17d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a50cb556fa9f26f3fb291aaa87a99a728980fed8d055427a5203781188b17d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a50cb556fa9f26f3fb291aaa87a99a728980fed8d055427a5203781188b17d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bdfcf623cea369b6d9ca67dea6888de9866b60efe723f87c28580be572c4eb1"
    sha256 cellar: :any,                 x86_64_linux:  "d6c24f2a5ac7feb2eb678835edc6871fb61a89480f61e74a11219441b4561b8b"
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
