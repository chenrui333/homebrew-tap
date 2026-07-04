class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.38.tar.gz"
  sha256 "19dc83ecd2e5c502174c268d7538a583ae302348b2f7949604b4ed5652ae474d"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00dd72fbd4b5926110d7ab36b6ef8f534b066a392d268b640ea505cfaf63dd9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00dd72fbd4b5926110d7ab36b6ef8f534b066a392d268b640ea505cfaf63dd9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00dd72fbd4b5926110d7ab36b6ef8f534b066a392d268b640ea505cfaf63dd9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4621a300c6c3b6df54181549a7e0d111044d793b3a3d394472ff68c5a1472cc5"
    sha256 cellar: :any,                 x86_64_linux:  "2059175580c534bbfcef4d0dc1b20530e2e1a0b6c0407c32c62cb2cbc59adb0a"
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
