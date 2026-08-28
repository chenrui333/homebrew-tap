class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "9f834e916b5038bdbebba4dfd18283e2ead1648d305c894aa87520ccb8e875b2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c89864eff9a10a17b5ddb04de8c425a1697d6955c44f51315b0c4d952f61fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c89864eff9a10a17b5ddb04de8c425a1697d6955c44f51315b0c4d952f61fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7c89864eff9a10a17b5ddb04de8c425a1697d6955c44f51315b0c4d952f61fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33202c8b80d4bc6284a8daa6b6a310fdebec46632c7791f29f2d12e3e19c7746"
    sha256 cellar: :any,                 x86_64_linux:  "5c4f1ac44b5dcc89aac47f7dd689522ccf2cd51e70156bc060f650525cbbb0bb"
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
