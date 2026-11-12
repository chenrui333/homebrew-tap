class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "2c4249c3551dae233d4c70274b785ce0b74bbcc78e5b56d0a6ef65b7f8501dcf"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a315ecff0604f658e163935e43f8e92b757475ebc2849f008e86bc9d0c6160c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a315ecff0604f658e163935e43f8e92b757475ebc2849f008e86bc9d0c6160c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a71345f593fffea36bb7ac0c94a0cbc1302563dadba15516af816abd20b95c2"
    sha256 cellar: :any,                 x86_64_linux:  "4b8bedd227adc7cae94e01d48d46895b5dbb60b09a67f528ac8371d6a567dafc"
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
