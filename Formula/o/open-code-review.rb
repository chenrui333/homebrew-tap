class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "728282af135225c0ecade0412bc9200061a703c7afed6dbd3e954efe364da259"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c82fb2b9fc0a990ae885722ad5d04731fe99f0a87df216e123c1d0bf9f53072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c82fb2b9fc0a990ae885722ad5d04731fe99f0a87df216e123c1d0bf9f53072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c82fb2b9fc0a990ae885722ad5d04731fe99f0a87df216e123c1d0bf9f53072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31dba687fa14258f2892ddacd3f7d66a9180ac4bd0fde0ff4aa1bd984d2bf648"
    sha256 cellar: :any,                 x86_64_linux:  "037818adc6b8e67747a2a4dea690398fb1c9dc29365f66b75a269fb1637db5c9"
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
