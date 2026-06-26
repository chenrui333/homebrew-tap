class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "f9dbe76a625515ac9871f393ba1ee9392c8985f8cfc2d1c2a5543cdf70da44f8"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d80ec7e6ffe2d537439261a0ac1ed8a613e6f0cb6825dc069c7baac71e7b4850"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d80ec7e6ffe2d537439261a0ac1ed8a613e6f0cb6825dc069c7baac71e7b4850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80ec7e6ffe2d537439261a0ac1ed8a613e6f0cb6825dc069c7baac71e7b4850"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f22a940bb0956135d59f159b5415cee96fc57624f96c659bfda992d05dea6d73"
    sha256 cellar: :any,                 x86_64_linux:  "342354ed92e2eaa3079f318e3e30967627c963c8e680a18dd29b8d22a667c035"
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
