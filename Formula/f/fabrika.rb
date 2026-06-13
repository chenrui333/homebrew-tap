class Fabrika < Formula
  desc "Software factory that orchestrates CLI coding agents as a managed team"
  homepage "https://fabrika-ai.com"
  url "https://github.com/berkaycubuk/fabrika/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "68e745625269ff3ed5d1b9806893432a7f0665a963d7305af07bef41b19b18bb"
  license "FSL-1.1-MIT"
  head "https://github.com/berkaycubuk/fabrika.git", branch: "main"

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
    assert_match "fabrika", shell_output("#{bin}/fabrika --help")
  end
end
