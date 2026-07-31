class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "efe57b9b6db7367e3bc8b8f3ac5d5cfa983a7ebcb59a7691fbd29f2eafac4467"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c67e319511fa962fff9f45fd971138707ffd214524be586e26e40923b0d3bba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67e319511fa962fff9f45fd971138707ffd214524be586e26e40923b0d3bba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67e319511fa962fff9f45fd971138707ffd214524be586e26e40923b0d3bba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cba708752443af2161c671140550801bd109f345008d8d52df5e009e9a17c43"
    sha256 cellar: :any,                 x86_64_linux:  "83d403f3141971b51e891e5eaa07a5f83950573bf3e3dec1c00e17b7d47371d0"
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
