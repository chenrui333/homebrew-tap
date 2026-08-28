class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.36.tar.gz"
  sha256 "a3882b7ffbd81b0e69b839177774b024ba14fa2e6a03225f63b5e928bfd509f8"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f417f20e6fb939f81f62b0671fcbbaa7662577b8448079de7b30d8cb0d905322"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f417f20e6fb939f81f62b0671fcbbaa7662577b8448079de7b30d8cb0d905322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f417f20e6fb939f81f62b0671fcbbaa7662577b8448079de7b30d8cb0d905322"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64c27ed97922976a068bb0a97a342c0278d43d137499db4a23acdb551129f0a5"
    sha256 cellar: :any,                 x86_64_linux:  "64bf1827e08ffff56ac8d289ff1faaa6f64befa57e7d7ae16b75704e2eb666f4"
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
