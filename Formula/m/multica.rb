class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "289a8f6e76d7668a215716faa8a77d5050be33de17e225185ccbd9e8b3a18ebc"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad17c5b28885e38d7f8593c8579fd56144fc388bbfd4f0495ebc8301b9afb30e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad17c5b28885e38d7f8593c8579fd56144fc388bbfd4f0495ebc8301b9afb30e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad17c5b28885e38d7f8593c8579fd56144fc388bbfd4f0495ebc8301b9afb30e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8eaf09dad9b88ba3814a054800a419fd98c91c81e6c8a3bfd1b5a9ed44eae9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e5031106e455be87e690f2b32c30314505c4fb97c8cf8025622d9706b1d62f"
  end

  depends_on "go" => :build

  def install
    cd "server" do
      ldflags = %W[
        -s -w
        -X main.version=#{version}
        -X main.commit=#{tap.user}
        -X main.date=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/multica"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multica version")
  end
end
