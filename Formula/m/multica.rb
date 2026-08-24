class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.33.tar.gz"
  sha256 "82834bad32d0c9ab16fd3c96a93ecc0367168806a4fd368233b4d69e7d8e43ae"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53331f68a64a61ebd9e3da1445194c3b43b29dc45dfd9c524f80a1ede787fd1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53331f68a64a61ebd9e3da1445194c3b43b29dc45dfd9c524f80a1ede787fd1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53331f68a64a61ebd9e3da1445194c3b43b29dc45dfd9c524f80a1ede787fd1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d80460c6166658ee1cc91a7520ee1a921659dd2cdb3c9593c8cc100d74d09f05"
    sha256 cellar: :any,                 x86_64_linux:  "0b01e456e77a033a3bc9b2f7e48e0390621374e72e9da219284e1893768a67b6"
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
