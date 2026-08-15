class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "cf948a888db50936492995e9da72320457ba0aad2add9180f2635930051c7a52"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a0806ffb77530fc41a310b8a6f17952ffbc96523288d1ad893dd7844e7914ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a0806ffb77530fc41a310b8a6f17952ffbc96523288d1ad893dd7844e7914ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a0806ffb77530fc41a310b8a6f17952ffbc96523288d1ad893dd7844e7914ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40d70bc0847680cb8c7604b5248515f7ad0af9aa5b99ad81c33416bdaa732f08"
    sha256 cellar: :any,                 x86_64_linux:  "07c218ab8f6401423c7df38dd266dbaddf2ffcad8e4eabc1f30fc1b2b0f2a4c7"
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
