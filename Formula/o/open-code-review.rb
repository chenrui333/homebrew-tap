class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "0f89e3e7c29a788eca37688599cd3c8f57e4f1be811feb2738fd7f1d2b987b52"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6960d403a367fc86df28be8e21a85a6a058240bd7a0cfe36dbfc2d6b7b87d563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6960d403a367fc86df28be8e21a85a6a058240bd7a0cfe36dbfc2d6b7b87d563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6960d403a367fc86df28be8e21a85a6a058240bd7a0cfe36dbfc2d6b7b87d563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1238f5cc6d65b331d64cfd7820ff792bbe5523854ce07695b386320cf3a8db14"
    sha256 cellar: :any,                 x86_64_linux:  "639f7f22446a5a7a38cf192fee7fa2957fab390ef95109897ee495f4372886b8"
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
