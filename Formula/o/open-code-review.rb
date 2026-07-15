class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "4baf2f3b5ed5089f631f951956acec27a8db45619f13fc41f7ce585d37cd74c0"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adef765daa9c7aef1748a2476ac1a21fe591210aceb085e2077f8be85b01455b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adef765daa9c7aef1748a2476ac1a21fe591210aceb085e2077f8be85b01455b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adef765daa9c7aef1748a2476ac1a21fe591210aceb085e2077f8be85b01455b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8320f5519ade146e9c5dccd0e37daad3fc4e05ac0133d4f1a257f2555d8a7b20"
    sha256 cellar: :any,                 x86_64_linux:  "1614cd786aaa8c241fbf0a36ae74722a566c4903a955bc69d05b7fa6cf8f2b68"
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
