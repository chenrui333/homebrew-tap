class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "47936f882ebb069fbba9d326fb63cf8f3778dd55c1b150b378ac885c33469d53"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4236b34c78c7dd6c5c26d202c6b48072b22ea2fc74a2532dab7b8aaaf8816df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4236b34c78c7dd6c5c26d202c6b48072b22ea2fc74a2532dab7b8aaaf8816df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4236b34c78c7dd6c5c26d202c6b48072b22ea2fc74a2532dab7b8aaaf8816df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c8838d2e140f1a876fdaacc614731eff9e3ad8e373799c3ee52aba255ce4230"
    sha256 cellar: :any,                 x86_64_linux:  "b45a6c1c59b9eac34355bc223bd57bb1770eaf89a17467b56d9d7bf7493b1b07"
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
