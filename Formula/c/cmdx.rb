# framework: urfave/cli
class Cmdx < Formula
  desc "Task runner"
  homepage "https://github.com/suzuki-shunsuke/cmdx"
  url "https://github.com/suzuki-shunsuke/cmdx/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "7cc1937afb4f860ed95ce4d3e2b6afbd22597a2b0029efa495d0e2f73acebd33"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/cmdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b693484af73b580ac5408d0faa2a62a1f63db602936331d88af3560b2de1bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b693484af73b580ac5408d0faa2a62a1f63db602936331d88af3560b2de1bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175da2bffecdcab9046fd07429861515a4d6efbf98da37499ba0bc9eec6b4ac7"
    sha256 cellar: :any,                 x86_64_linux:  "1f46b9a7245e27ef5a57c64e4ef26de652a6e5a40beb5666bedcdcb658936e41"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cmdx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmdx version")

    (testpath/"cmdx.yml").write <<~YAML
      version: 1
      tasks:
        - name: hello
          script: echo "Hello, World!"
    YAML

    output = shell_output("#{bin}/cmdx hello")
    assert_match "Hello, World!", output
  end
end
