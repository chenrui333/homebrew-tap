class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "5d6bc53b5f5ffd5885b7e9295ff92fce8058e19b01b8690366f9e11636eb186c"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b18f64f47ec9b584c8185cfe8e49ffac894ccdba6328e8af649db64d30c6310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b18f64f47ec9b584c8185cfe8e49ffac894ccdba6328e8af649db64d30c6310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b18f64f47ec9b584c8185cfe8e49ffac894ccdba6328e8af649db64d30c6310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cfb4705ffe6b7377dcb02468f06e7da2834e047daa7cb126e47a483897bfa80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4704532c2535e6385700cb47d16c0b5bb183dbef07e455a1c0140f4bb8aa72d3"
  end

  depends_on "go" => :build

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
