class Bombardier < Formula
  desc "Cross-platform HTTP benchmarking tool"
  homepage "https://github.com/codesenberg/bombardier"
  url "https://github.com/codesenberg/bombardier/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "d908c050132b3a33c3d292a6a3b47d088284a5969376f68f05d7409f51f01e41"
  license "MIT"
  head "https://github.com/codesenberg/bombardier.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bombardier --version 2>&1")

    output = shell_output("#{bin}/bombardier -c 1 -n 1 https://example.com")
    assert_match "Bombarding https://example.com:443 with 1", output
  end
end
