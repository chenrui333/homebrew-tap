class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "807012cea629578b074ebc0d488a4553cacc7600e079c47e78d280a3fc385eec"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5de8ce34652b54274da1aeed72c0b87cddb6332df08fcb72ea1da5f5f20a8d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5de8ce34652b54274da1aeed72c0b87cddb6332df08fcb72ea1da5f5f20a8d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d88202dbf25476bf614bfe0e7af2ea6e40bd8d63ef78437530293a9b209b822"
    sha256 cellar: :any,                 x86_64_linux:  "5e3843d4d0b17188920934a4c2801977535c0465ac5f8e6b6a55bcd16c236286"
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
