class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "4693797f7072d87eb7c02cd9bd009069a52da259497cd51e7c8f6aee5df71185"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4b975fce9981111a1a2e0b11600398e8228ba5ea0ee27f60ba7488dc163d164a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b52192087f6117eaa975943f2584b65f17958e3fc85b4ed0b81842ba31d25f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b52192087f6117eaa975943f2584b65f17958e3fc85b4ed0b81842ba31d25f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e05ab62458a450e72e7243ad95a4e6458d8c6f456cda65a30c93a3539784544"
    sha256 cellar: :any,                 x86_64_linux:  "a3fb5fd57221ddca0b30590fb5a0c4492a17633b5261733274dcf53269a5b5de"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"
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
