class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "3e1d9a1c7a2d25214563a0c034eef781cfb308418887c1e0e27fcc8aaaf554e2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "016cddc13fbf93d0f902e5d40621a96cdfc7dffe8af419d9885919d3d65505cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "016cddc13fbf93d0f902e5d40621a96cdfc7dffe8af419d9885919d3d65505cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "016cddc13fbf93d0f902e5d40621a96cdfc7dffe8af419d9885919d3d65505cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae195aaacefe89dbc187f2993c1778cc5636adbd3f2ada70d35b3e61423abf79"
    sha256 cellar: :any,                 x86_64_linux:  "c59f81c3340b6dc8e38f713663c796a310404f1b52f726582859eab0b193a420"
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
