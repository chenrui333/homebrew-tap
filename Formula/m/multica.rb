class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.37.tar.gz"
  sha256 "67cf7348c731c1793dc35df4c58e2f03aea3e51c9c4fe640e6acda49d1da05cf"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dfa79c445df7024cb92c72a5f70d80bd4285b48a4f04ff9259ab071485e41a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfa79c445df7024cb92c72a5f70d80bd4285b48a4f04ff9259ab071485e41a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dfa79c445df7024cb92c72a5f70d80bd4285b48a4f04ff9259ab071485e41a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d810a6f06c92b0da83bc916d85f1d012f3966c80b1349af12a949a3744afee23"
    sha256 cellar: :any,                 x86_64_linux:  "53918960659f55569a877262795b11a8512bcc764b300824c639f8eb90ee6588"
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

    system bin/"multica", "config", "set", "server_url", "https://example.com"
    assert_match(%r{^server_url:\s+https://example\.com$}, shell_output("#{bin}/multica config show"))
  end
end
