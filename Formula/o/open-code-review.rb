class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "7e49d97ba752f71001f9bab548086c2ae8d98c103cde4912a5d9ba67800a66e1"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af2625ebae998f71338938165f027c5b59b1450d8e4dc6b32e5c047410b8336b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af2625ebae998f71338938165f027c5b59b1450d8e4dc6b32e5c047410b8336b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2625ebae998f71338938165f027c5b59b1450d8e4dc6b32e5c047410b8336b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae8795f9eb2d3b988779ce0a03510bdad45c6da613a1009d1aa722d735ce008e"
    sha256 cellar: :any,                 x86_64_linux:  "56c544b8703a3521654636709c93b760b0a8194e3f150d44a88d5c66792ada03"
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
