class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.36.tar.gz"
  sha256 "a3882b7ffbd81b0e69b839177774b024ba14fa2e6a03225f63b5e928bfd509f8"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f47f1f4abf02edbac62bba2d965e873ccf6ee6160caffbcaa425da8a5b6a8e7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47f1f4abf02edbac62bba2d965e873ccf6ee6160caffbcaa425da8a5b6a8e7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47f1f4abf02edbac62bba2d965e873ccf6ee6160caffbcaa425da8a5b6a8e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a9b4609ea921bd6fdf15f45758e3df7b7dbb79bb70d8ac163a9bfed3f505d3"
    sha256 cellar: :any,                 x86_64_linux:  "cbb97d6575f249ebec6d37d7c79e0e1875c8aae2d849fedd721733fa1d40057f"
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
