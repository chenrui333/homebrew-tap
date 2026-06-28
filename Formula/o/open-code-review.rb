class OpenCodeReview < Formula
  desc "AI-powered code review CLI tool"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "a3c967374f4555002edacde197b8b217139c8bb7c1fa1ad9c5964a8026841587"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81db214011f7ab49bb62f316a490cc6e22929015c68d711dd0c35b076d1b77df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81db214011f7ab49bb62f316a490cc6e22929015c68d711dd0c35b076d1b77df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81db214011f7ab49bb62f316a490cc6e22929015c68d711dd0c35b076d1b77df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a38876229ba1b176cd5b3841f72665d56dd0a859385198c61234ed6c2657ebd"
    sha256 cellar: :any,                 x86_64_linux:  "8809b8e9ed2213a0dd14b71928f76ea3bffd3b172e1f1289819fc89aa2d62378"
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
