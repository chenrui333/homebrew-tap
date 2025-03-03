class Kt < Formula
  desc "Kafka command-line tool that likes JSON"
  homepage "https://github.com/fgeller/kt"
  url "https://github.com/fgeller/kt/archive/refs/tags/v13.1.1.tar.gz"
  sha256 "75031bd1d63b08b4f3d8e4b59eb1c9157d21d69f483bb1355933dc09f50f888d"
  license "MIT"
  head "https://github.com/fgeller/kt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4957a71a790eb96db793042c77f2b0b1127ff64dcd94a058293f996905f7edcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b222b91c09fff82bb36f76b9953074332f1e6efff6a8b0d2ece02770ea71d5"
    sha256 cellar: :any_skip_relocation, ventura:       "6c999627aa0c1fe8a16ad2e8e6f07b0e3fc14ea5eb92c83908c93bc481befcfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd1732e2248a981db97691cd9b8776230da921b03f56ec2ca86ea54f6c242cb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kt --version")

    output = shell_output("#{bin}/kt produce -topic greetings 2>&1", 1)
    assert_match "failed to find leader for given topic", output
  end
end
