class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.16.tar.gz"
  sha256 "6c7cd22b6bfd007c13063c5c1581083790a79048028ac527efbab8be83444ba8"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "406c466de3d3a006f9f96a971ed263c8cb70be84862f4afad222ada6d5c3e93d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406c466de3d3a006f9f96a971ed263c8cb70be84862f4afad222ada6d5c3e93d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406c466de3d3a006f9f96a971ed263c8cb70be84862f4afad222ada6d5c3e93d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87e64b8f428cb516e0b0703b3260cf450c14afa4a721343b14ca93a1349dae1e"
    sha256 cellar: :any,                 x86_64_linux:  "205e97e8c0d25bbd873a5de4f34f8ec6b65eb29e74294979f1f4289c74268394"
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
