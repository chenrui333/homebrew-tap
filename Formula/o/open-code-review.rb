class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "9bf0c298080cc73d1d8339174b8fb7e4549abad605d6f7b22ca4ce8bf572b66b"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a507b014cd5603e4cac584704c9a7803ad84998111ee26f76bcb5613efcb520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a507b014cd5603e4cac584704c9a7803ad84998111ee26f76bcb5613efcb520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a507b014cd5603e4cac584704c9a7803ad84998111ee26f76bcb5613efcb520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d69ecaec95240efb79bf4f8ab583954c90094c9f41d29859d49e6d19de8a4de"
    sha256 cellar: :any,                 x86_64_linux:  "07564186b377d8bf9c64512978da7ee3a12ae7bad7896c1a302812c97b5b2609"
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
