class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "9dedd43cef704fd44fe8b5ed8904d82a4b6d5bd1ac9d4324a85424c20e6c2a64"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "163fa3eb097f90f64c932c6b2a7f542655b16e602a241f32f20b714cf7d95c04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "163fa3eb097f90f64c932c6b2a7f542655b16e602a241f32f20b714cf7d95c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "163fa3eb097f90f64c932c6b2a7f542655b16e602a241f32f20b714cf7d95c04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e325e16af4925f28f956840ebe6a8d24443dc7780d39982952c38c773c9ecf"
    sha256 cellar: :any,                 x86_64_linux:  "02a1230a6651a41c0b84b31f6c4f14fa4bf1563ff90f54acce90d2f9ab535f90"
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
