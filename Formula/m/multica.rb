class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "ca6a31f81635d8c10d7eefed05a9c2ed6c5d387e33b87a442e863379623c103e"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9393b8a2fbf1d6ad634513f4af696ac7ca39c52b4a1e835fff2e1a6a9bdc066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9393b8a2fbf1d6ad634513f4af696ac7ca39c52b4a1e835fff2e1a6a9bdc066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9393b8a2fbf1d6ad634513f4af696ac7ca39c52b4a1e835fff2e1a6a9bdc066"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048319d855a0cf3dc4c2e6d18cd1c358335f2384c46d14ab08f7d56f0155cbf8"
    sha256 cellar: :any,                 x86_64_linux:  "a95476df0f1bf235c7af6d6978c56ad145fe962eb0c3a1143fd71d3a45cab36e"
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
