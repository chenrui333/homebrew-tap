class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "a829f329cb39a4ad6c617b7b70e5152597691f38cdf919c842214602e4e81bdc"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09b7f2ef56730b476cf75f39ba3dae3840721bb2893c0f75218649e3dd16ec41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b7f2ef56730b476cf75f39ba3dae3840721bb2893c0f75218649e3dd16ec41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09b7f2ef56730b476cf75f39ba3dae3840721bb2893c0f75218649e3dd16ec41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dd9741478633185a759adda7bb9d494c476319ad9ac9660071d7c586120a926"
    sha256 cellar: :any,                 x86_64_linux:  "34cc4d484bb3b1aa2b24ceab01feba00140a04fe2a5d0edde4acb9e2e792d04c"
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
