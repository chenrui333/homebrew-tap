class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.3.19.tar.gz"
  sha256 "e450647dd8e7201672a7c5bd67c358de6b2ed12af58fa61cd91bf52a22b196ba"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "253514c2d9dbeb486479d19181c372efabf183dd603e7a6af1c19dcb3cc749bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "253514c2d9dbeb486479d19181c372efabf183dd603e7a6af1c19dcb3cc749bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "253514c2d9dbeb486479d19181c372efabf183dd603e7a6af1c19dcb3cc749bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a775a43e146c128b816fba89c312211370bcb7e55aba21ea11ffcf2fdfe898f1"
    sha256 cellar: :any,                 x86_64_linux:  "9231b43be38b061508f3078084ad4da77929a84db18dccd3fba7de9e7199f470"
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
