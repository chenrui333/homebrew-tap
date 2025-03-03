class Kt < Formula
  desc "Kafka command-line tool that likes JSON"
  homepage "https://github.com/fgeller/kt"
  url "https://github.com/fgeller/kt/archive/refs/tags/v13.1.0.tar.gz"
  sha256 "20cffe44f0f126ee42c634427cc3cdb6705e33dd4de3647a8c4a84ccec1d25f3"
  license "MIT"
  head "https://github.com/fgeller/kt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ebebc1f334db10a2b34e2f0328df97dbfde76f47f4bf524faecd6b5b3ba5f91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3aaf3437195b988829e9b3744285bbeb62f0a54090ec9a3f622b035ea79d6bd"
    sha256 cellar: :any_skip_relocation, ventura:       "4b000b09986b5cb600a701dbabaa0b20fe6e57ef050ea7ade0a7f48e4147c7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b35e31ffbc9b2326e265f414571e891efda3eb1d67e01d8b5f3085f810defb2d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kt --version")

    output = shell_output("#{bin}/kt produce -topic greetings 2>&1", 1)
    assert_match "Failed to open broker connection", output
  end
end
