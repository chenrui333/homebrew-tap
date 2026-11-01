class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "140daa356fae474183ac329e17fdee35b391282ce36c879d7d4e487420df3c52"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4eb803257d744e59f59c7c405fce67f0eefb501f61594dcaab423531270d93a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4eb803257d744e59f59c7c405fce67f0eefb501f61594dcaab423531270d93a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "794a2bcf1c8cb03de62baf5a7fbe87913e599fc4c30e8a806e3631cfd4d7e010"
    sha256 cellar: :any,                 x86_64_linux:  "54fff77a8a7d321e0267ca11fd9a376793c40599396a41ae87f60a3a42d91328"
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
