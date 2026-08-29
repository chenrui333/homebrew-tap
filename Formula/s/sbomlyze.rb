class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "084e712ad2010990e337aeb14b915435d166b30bbf19892ac1ca172d503cc0b7"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e92a2eb4c60041e3d340324ee5166af83b2850fde76453e2360ec22c95926db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e92a2eb4c60041e3d340324ee5166af83b2850fde76453e2360ec22c95926db6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e92a2eb4c60041e3d340324ee5166af83b2850fde76453e2360ec22c95926db6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "114a191e63a69c160fc156b1d0683dc4807c1ce1d63e0aa83822229b939b6f47"
    sha256 cellar: :any,                 x86_64_linux:  "46a3691d0afb7db27ffb2fd8ba99e991ed77a64496984d6d9e2093f74e5fb8ee"
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
