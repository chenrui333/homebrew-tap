class Urlhunter < Formula
  desc "Recon tool that allows searching on URLs that are exposed via shortener services"
  homepage "https://github.com/utkusen/urlhunter"
  url "https://github.com/utkusen/urlhunter/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ef7d6719d9a824a5614808c9408bd3dd73dda1049feaa7f65442b1c44602aa13"
  license "MIT"
  head "https://github.com/utkusen/urlhunter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2abd85bbc5473b757770234f2af3b926c2c334e77cfe8fe03b8e1660062b4c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2abd85bbc5473b757770234f2af3b926c2c334e77cfe8fe03b8e1660062b4c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2abd85bbc5473b757770234f2af3b926c2c334e77cfe8fe03b8e1660062b4c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "209283d7bfb2b722332f9626e4527eef339904ab6a820e7c7242f2ddb5422ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda3e49859b899c15f0b18a6444b78f80105440b1d5cdeb8de2ac57d0ddafe1a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/urlhunter --keywords #{testpath}/keywords.txt --date 2024-01-01 2>&1", 2)
    assert_match "[ERROR]: Error processing archive", output
  end
end
