class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "c1eb76e875866d1486c3d3964d4e6fef74275ca682d3ec24e1b42957109df4aa"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65ddad5a9ab88b422921faf746c47fd36be1c6d260f3392f21901f5ce1339d9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65ddad5a9ab88b422921faf746c47fd36be1c6d260f3392f21901f5ce1339d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65ddad5a9ab88b422921faf746c47fd36be1c6d260f3392f21901f5ce1339d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c9ec01410e84280ea5cc6dcdf5f5795fef08bfe6c3a827b7978a6289fb9f43"
    sha256 cellar: :any,                 x86_64_linux:  "11fe1845b8b2bca80e25044236a0c968cbdad893a8bf83cf217d8c90da74bb25"
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
