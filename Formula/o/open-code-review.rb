class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "c52c33ab088b4e86295fc4dd7b3bc2bba5ec9e78af0a8527a8da2eb8b5e3c2aa"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c84591e882bb85adac3dd1b62667a13583e7fc2488f9d125243c0b46267ea2c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c84591e882bb85adac3dd1b62667a13583e7fc2488f9d125243c0b46267ea2c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c84591e882bb85adac3dd1b62667a13583e7fc2488f9d125243c0b46267ea2c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e16c3358f77dafea9a249cdf27b1c3cdaee0a60b1aaaf0acde7acdc9a436629a"
    sha256 cellar: :any,                 x86_64_linux:  "ca161dd00ab355f27fb705575de04918c4bb89232fba6d8c9369d6cb82ae9fbf"
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
