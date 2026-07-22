class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.7.15.tar.gz"
  sha256 "58cb9cb1001228fde8f3dc36e544d2203462a21da3677a46fdcdfd1bbdca452c"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "354b77716e8a0a55bf5e84ad65617ea207f4d599447b5d2c6ecd44b91db30087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "354b77716e8a0a55bf5e84ad65617ea207f4d599447b5d2c6ecd44b91db30087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "354b77716e8a0a55bf5e84ad65617ea207f4d599447b5d2c6ecd44b91db30087"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3f7cecc1f0eabef7048761b90fde8ae50c0eca78fd82020eac3277a5835f8b4"
    sha256 cellar: :any,                 x86_64_linux:  "bebe26db32ea3d0490bbf2c8d2299a5d8b7e4f9521a48ecc15a3db7d6fc87df1"
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
