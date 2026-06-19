class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.3.19.tar.gz"
  sha256 "e450647dd8e7201672a7c5bd67c358de6b2ed12af58fa61cd91bf52a22b196ba"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29d38de13007689dd59e91cb7ba76b8e601ca8d18bc878b7fcf23d1b9676afeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29d38de13007689dd59e91cb7ba76b8e601ca8d18bc878b7fcf23d1b9676afeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d38de13007689dd59e91cb7ba76b8e601ca8d18bc878b7fcf23d1b9676afeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d553a657c771727cea7cd47b19f45a5d8f9eec115ae7a305aded62f282dc8f4"
    sha256 cellar: :any,                 x86_64_linux:  "2df460c1566cc6192c73f460d26cb3fb90498bb0250bb3da6168a3a2799cedda"
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
