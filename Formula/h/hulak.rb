class Hulak < Formula
  desc "Lightweight file-based API client with encrypted secrets store"
  homepage "https://github.com/xaaha/hulak"
  url "https://github.com/xaaha/hulak/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "a09150178062038f73d541993aad643213917639d5c0473cdb3feab2660ade79"
  license "MIT"
  head "https://github.com/xaaha/hulak.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/xaaha/hulak/pkg/userFlags.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hulak version")
    assert_match "Initialize a hulak project", shell_output("#{bin}/hulak help")
  end
end
