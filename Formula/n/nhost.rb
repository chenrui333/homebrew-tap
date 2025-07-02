class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "bce7e22295a6568c6c99618df3dc4d3f8de23c1cb06f0012ba5c7561974e28f1"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58cdf058b7bee2635c4e8948d74d3caf122d873ebaabd9ffef54dad01322760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72bdb35d188be21dc7a28315aacbb4ed28d77fe6735a42d44754e06867e267d9"
    sha256 cellar: :any_skip_relocation, ventura:       "10cbf2a0d56600cc87735c0096709633d8d561c6839e3c3d2e73d59fbad6d3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc949787323f5eea9784265d7388e49963cc8098ad376ebaa33d0d40b6ba630"
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
