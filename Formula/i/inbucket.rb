class Inbucket < Formula
  desc "Disposable webmail server with SMTP, POP3, and REST interfaces"
  homepage "https://inbucket.org/"
  url "https://github.com/inbucket/inbucket/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "40035d9430da76d614bc6f09dc9c501bb857ed7b6d991c7374b9aea24d2e66ff"
  license "MIT"
  head "https://github.com/inbucket/inbucket.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9baa01080d94b10393104e302a8feaeaa805b48ed157ce76ce700e52200ba221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9baa01080d94b10393104e302a8feaeaa805b48ed157ce76ce700e52200ba221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ab5c83abe0520361a2d931b0db1a5b97f9c3a6f33a32e288d311c16e7e4bcde"
    sha256 cellar: :any,                 x86_64_linux:  "699c8703673d3210628a7b3badf0f8a9b2d0f249cb14671f769225968111c0aa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/inbucket"
    system "go", "build", *std_go_args(ldflags:, output: bin/"inbucket-client"), "./cmd/client"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inbucket --version")
    output = shell_output("#{bin}/inbucket-client list test 2>&1", 1)
    assert_match "Couldn't build client: parse \"http://%slocalhost:9000\"", output
  end
end
