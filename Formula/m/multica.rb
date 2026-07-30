class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "5561df7e363891738253361e9240f06992852a5ceb89338d682fd18625829c3d"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "069e224a412306910fddba728aeaf2e61212d889f321e4d3e84522ce10cb13bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "069e224a412306910fddba728aeaf2e61212d889f321e4d3e84522ce10cb13bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "069e224a412306910fddba728aeaf2e61212d889f321e4d3e84522ce10cb13bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195df03ff32c2f3df8048623737e2e9f40843182deb082ba1a50f8974fa4e0e5"
    sha256 cellar: :any,                 x86_64_linux:  "bf26ebb8c86ba73eb98eb0aaf6f3607dbd307edef3065064148d9c23fab8bc89"
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
