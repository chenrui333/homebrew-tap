class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "5477ec6d88aa15d494719bed2066ca7bc1b97d3cc7023476da66aab6d876be48"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d37372af22b77524578147e28bebdbd8fb73f4067a9d5021a4aa924f8e641f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d37372af22b77524578147e28bebdbd8fb73f4067a9d5021a4aa924f8e641f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d37372af22b77524578147e28bebdbd8fb73f4067a9d5021a4aa924f8e641f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "275952e2c82e202decd2ddb6089dc5aa5fe4d2fb2ec036e51a631df3efd11204"
    sha256 cellar: :any,                 x86_64_linux:  "9cbb610d54bf414e92b474e20020998c930b2c49b600e5832cba8ffc71d799fd"
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
