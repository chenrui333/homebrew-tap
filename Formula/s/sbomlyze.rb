class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b262d01e3c2718d6964c66675725cd037b9e9b401fff855e4535813ac56a90b6"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a888eac0787987d628786d52418f4ead491e2da7ee08d65af0bbbf23553efaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a888eac0787987d628786d52418f4ead491e2da7ee08d65af0bbbf23553efaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c6bc14395b28c93de0ee8bc3a624d3fce165ec0d9cb2934d95988b57f5618f7"
    sha256 cellar: :any,                 x86_64_linux:  "ec2bcd400d818ea3d725e6a9dfd53637405c1124d11a5a53ac97c3a514719ac8"
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
