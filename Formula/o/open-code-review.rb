class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "9bf0c298080cc73d1d8339174b8fb7e4549abad605d6f7b22ca4ce8bf572b66b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe2a3697b910d786f5a389a2c22254ed008e77636e594377edf5389b3b62e45c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe2a3697b910d786f5a389a2c22254ed008e77636e594377edf5389b3b62e45c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe2a3697b910d786f5a389a2c22254ed008e77636e594377edf5389b3b62e45c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59041b17bf1086eb391efc2e7ff0862f1990deb4a64cdc44e9cc0f8d75ac0f6d"
    sha256 cellar: :any,                 x86_64_linux:  "a8c88320d1e945940c6f5b4ef96762915b4e2bb9531878a131ba72aa59b92946"
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
