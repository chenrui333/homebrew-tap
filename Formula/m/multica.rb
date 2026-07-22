class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "ca6a31f81635d8c10d7eefed05a9c2ed6c5d387e33b87a442e863379623c103e"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0003647a761ab016a3574fbf0fe85a399671975c9f78d5c330e28d60bd692f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0003647a761ab016a3574fbf0fe85a399671975c9f78d5c330e28d60bd692f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0003647a761ab016a3574fbf0fe85a399671975c9f78d5c330e28d60bd692f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f18e5ffa5fbeeb97234b8a7b52ae28e83faa2574e485826d2517e0c4feaaa8"
    sha256 cellar: :any,                 x86_64_linux:  "ce9c5a60c6323a2b4e8351efb5340d644df7c15c1374b64303f54814b66197b0"
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
