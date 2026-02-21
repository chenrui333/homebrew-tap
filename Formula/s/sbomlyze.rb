class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4f276a96d15a460927407a4991881651e4a1640667dc8b2e9e00e45a7705ed7f"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf3dc1a1f53d00af3a1758f51fa2f2eafdc9be840567bee075ac9806bb8fda86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf3dc1a1f53d00af3a1758f51fa2f2eafdc9be840567bee075ac9806bb8fda86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf3dc1a1f53d00af3a1758f51fa2f2eafdc9be840567bee075ac9806bb8fda86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9cef542f5e1797664306eb79202c6d5e721527b193813e86a9338301e01022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59311f1a0e0b475a3d2605ad4ffa87924e5674ea514f0724ee3e2ef1f04c5288"
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
