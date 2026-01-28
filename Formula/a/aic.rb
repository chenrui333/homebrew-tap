class Aic < Formula
  desc "Fetch the latest changelogs for popular AI coding assistants"
  homepage "https://github.com/arimxyer/aic"
  url "https://github.com/arimxyer/aic/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "e9b9e86643b5723e62813a18907b62259899ae59c7935778cceb0308af96ede9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7d61f2cc701ebcd487d5ef055137d42dfb6e482cbc0ba15fe03138a857101e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7d61f2cc701ebcd487d5ef055137d42dfb6e482cbc0ba15fe03138a857101e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7d61f2cc701ebcd487d5ef055137d42dfb6e482cbc0ba15fe03138a857101e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e042b063fcef5669452d09f2af0d3f58d529b4a51dc6544f006f45684d7288a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95f9358b5d537b7611f16a463928e34fc781e40c7bcc0e367942de76cb37c15b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aic --version")
    assert_match "Claude Code", shell_output("#{bin}/aic claude")
  end
end
