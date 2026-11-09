class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9240584818227b2fcda2d4443214395fb918d9dd8663d0c174757053ac8f90bd"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bfa7dbb1a97d3796761f4cec6b506d897061db16f7841032a8b5c55bbdd7c88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bfa7dbb1a97d3796761f4cec6b506d897061db16f7841032a8b5c55bbdd7c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ae4c832031e8b716b7729fc1c50bc7505dd90c5fde98a286209114326d309ad"
    sha256 cellar: :any,                 x86_64_linux:  "e166c355f8c943ebfed00e8f2a10a9a3fb1ed70359e9aaad413875e29764a25e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/rezmoss/sbomlyze/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/sbomlyze"
  end

  test do
    (testpath/"empty.json").write("{}")

    assert_match version.to_s, shell_output("#{bin}/sbomlyze --version")
    output = shell_output("#{bin}/sbomlyze #{testpath}/empty.json --no-pager")
    assert_match "SBOM Statistics", output
  end
end
