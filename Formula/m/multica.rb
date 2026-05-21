class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "80e8d1c6fec082a0639e08a8381822b2bf25598b7d8936f7f0c79850550ecd51"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "329640006442acce1048f67030e3174983e115a3f1a4b81b448f32b4a696b032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329640006442acce1048f67030e3174983e115a3f1a4b81b448f32b4a696b032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "329640006442acce1048f67030e3174983e115a3f1a4b81b448f32b4a696b032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c14f9b7e9ea8a18f53e4e578f74a2b1d8712828c12cc3f8dca89ae7934e1e419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a9b2eb44c8e10d5e6a23bdd8ffe254c0a924ed9849e5925ffeca446592388a"
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
  end
end
