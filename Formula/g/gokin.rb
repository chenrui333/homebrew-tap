class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.81.1.tar.gz"
  sha256 "f8c4490fc8a632f5a71bf5312f7549b1c1e3dc015c5bb428fbddbdfdf1ffb99b"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9156ea6d068f8aed1498e13d9c904f028ebe804d10f51c32e907152609ed7389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9156ea6d068f8aed1498e13d9c904f028ebe804d10f51c32e907152609ed7389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9156ea6d068f8aed1498e13d9c904f028ebe804d10f51c32e907152609ed7389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47d95b59f7ad82d108d4842f37f5d7cabc11a3af92ac42059dcb9d5369ec5e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2264a40991898a2aa3934b5f777b5099e001c7100d257f5d2343dd8b7eedfdf1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
