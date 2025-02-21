class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.10.14.tar.gz"
  sha256 "2313dfaf89222b343c632e31cd5d726da825a1cfd2bb34370485e713b5e18826"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20c6c1d7572e93222cfc90f2a6df3cb21e2617751b2bb91367e5273ba8dfe71b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d69d4b5c6243be2437d96eb3b4d7a0f59be1b1f5413b2fab6bccec70335083"
    sha256 cellar: :any_skip_relocation, ventura:       "184cddcc9551ec2e4dbd7e49ba7ad1df8fc946b688f3416448d5c8ec838bd17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "172256924ac960dcc512b0aa5979e1359c7799ddc30373ae3fc054bb45afe50a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
