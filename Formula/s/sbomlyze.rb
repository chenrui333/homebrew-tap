class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "a9b2794cfdbdd849aa1ca44085fe3b518e260f77c45d9d76e719fd73b17d277c"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c612bba9f55b3c0eed42e5fd93f98888805bb8f73f369a47d40389830895399"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c612bba9f55b3c0eed42e5fd93f98888805bb8f73f369a47d40389830895399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c612bba9f55b3c0eed42e5fd93f98888805bb8f73f369a47d40389830895399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47e086cfc1c17d81899411d3cf1220eb013f9f71fca6bebf4a53029b69e58dcb"
    sha256 cellar: :any,                 x86_64_linux:  "26898c160973aa2990c5e55bccba633332437919749f2850420ef58ab491335b"
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
