class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/platform/cli/overview#cli-overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.31.2.tar.gz"
  sha256 "2619e2ae5cbcce7bee30971bbdda8057428fbb1e3600854bac6ad0923201e9f9"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73974c0e79cdec28593eed1a5d94d452c5e03e26d7b22192c6bca1a4228fad28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1a76c899aec80e8a91205929ae907482e1d1cb3b1260c8ea197b3b57123551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7a2c42d0955827ff821a15c02dd03f5764d931f835cd33b1a3b0334cb57069"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
