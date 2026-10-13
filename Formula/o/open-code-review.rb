class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "24813c739e94985e0468a424a2e3d25c16b0caa4060be0d47f6d7a2a82fc090c"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "144ce6a2e5775e8723f4600413a08df1edb9848860bbbff090ec7daaa79e039b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "144ce6a2e5775e8723f4600413a08df1edb9848860bbbff090ec7daaa79e039b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94817a220f13863e5804a16dba92df4973b0042502f8c5e1c0ad578a40544f7b"
    sha256 cellar: :any,                 x86_64_linux:  "016a22bfcb549be80cd585bf4f647c39615218f5fbb5ee7d1a630845c3278fd3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
