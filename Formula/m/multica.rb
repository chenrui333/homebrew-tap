class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.40.tar.gz"
  sha256 "aca50137287c2948bcf5507033ee18041534f455412a59356dabc59abfcb415d"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e3b7518f3c914736fbd4d8c179b68057a189dfa3a2e6a4f57fa234ffcc4f8f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e3b7518f3c914736fbd4d8c179b68057a189dfa3a2e6a4f57fa234ffcc4f8f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e3b7518f3c914736fbd4d8c179b68057a189dfa3a2e6a4f57fa234ffcc4f8f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6d65210737845e06b929e50cf50e2ae06c91c487b248ae85d5675ef4620fe6e"
    sha256 cellar: :any,                 x86_64_linux:  "77885e1836719239ee8609a7a7b1670ce8b47d8f69b80f2f0b25586e098bffeb"
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
