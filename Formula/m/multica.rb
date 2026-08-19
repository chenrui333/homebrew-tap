class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.30.tar.gz"
  sha256 "2786a59a9d66df857d9e40cb53a636d73b4f7ecf9bf7ba3ce206f356b8c09d71"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d35c36c2010647a36a813ec3d1a2b49fc1f77ab81ac497869ede90819080e00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d35c36c2010647a36a813ec3d1a2b49fc1f77ab81ac497869ede90819080e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d35c36c2010647a36a813ec3d1a2b49fc1f77ab81ac497869ede90819080e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7344e2fec9313fab66cb5e6e3ad2386be24d28fb87a081d97ce9d05bccd2fe3b"
    sha256 cellar: :any,                 x86_64_linux:  "c1ff21976d1b7bd28ea8d5254cfcf11d1e6cdad916e6b330025a37d5b64dd505"
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
