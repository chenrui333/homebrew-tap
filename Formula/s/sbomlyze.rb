class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "7999d0d681b4d72a2a47e8260a37e332eb819a0abca4b6569f4913027eb12f03"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85b3bfd1ef10152a1301f0ac189aa6bb859434aee16ccd78894e81fe7250bd57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b3bfd1ef10152a1301f0ac189aa6bb859434aee16ccd78894e81fe7250bd57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b3bfd1ef10152a1301f0ac189aa6bb859434aee16ccd78894e81fe7250bd57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd0da4930cc4a7d448cbf99da3d3c665339d29de69c909922cc5395d10166df2"
    sha256 cellar: :any,                 x86_64_linux:  "85a51f4df3a301bc34daa12c9f7e1e80da1db5f4685312cf31cacd242005fff6"
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
