class Fabrika < Formula
  desc "Software factory that orchestrates CLI coding agents as a managed team"
  homepage "https://fabrika-ai.com"
  url "https://github.com/berkaycubuk/fabrika/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7a7f900a6554629dfe9708a2e8074adc43e7385b77851f43d89d850ace049388"
  license "FSL-1.1-MIT"
  head "https://github.com/berkaycubuk/fabrika.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b924a6ae10c812e44a98afbdc74550e9027fb365ab378c2614a0486fd282aea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b924a6ae10c812e44a98afbdc74550e9027fb365ab378c2614a0486fd282aea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b924a6ae10c812e44a98afbdc74550e9027fb365ab378c2614a0486fd282aea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c0fc28d96424711150707a2ad69bfd8ecd11d0792aa31733ef8d96bfdf0efad"
    sha256 cellar: :any,                 x86_64_linux:  "2bb57e7080354fb55b0812d5b39be419051447a0f176d921ab178bf03cc41c8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fabrika"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabrika version")

    output = shell_output("#{bin}/fabrika --not-a-real-option 2>&1", 1)
    assert_match "flag provided but not defined", output
  end
end
