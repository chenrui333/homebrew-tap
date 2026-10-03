class Packemon < Formula
  desc "Terminal tool for generating and monitoring packets"
  homepage "https://github.com/ddddddO/packemon"
  url "https://github.com/ddddddO/packemon/archive/refs/tags/v1.8.30.tar.gz"
  sha256 "4bf6ad445104c641e9023a76e38966d397d9b55e58571b115c7931d151f45e74"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/packemon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1883322aef7e5bd48cbe07144d693097f28cee5cd850ceab458235588e52e953"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4330efacddc7510d895c58506019c9aff089df04f4bc95199248a6b478f7457c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca7ee4b0502a910fd41036b2d22b168ff11df5a0177ee0bd2956bf3b3c499fe2"
    sha256 cellar: :any,                 x86_64_linux:  "e9c0a7c7be22cdda11fa3ca394566ab45a6e38f16626f9737efbd2fca06e0dd0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=brew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/packemon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packemon version")

    interfaces = JSON.parse(shell_output("#{bin}/packemon interfaces --json"))
    assert_kind_of Array, interfaces
    refute_empty interfaces
    assert_kind_of Hash, interfaces.first
    assert interfaces.first.key?("InterfaceName")
  end
end
