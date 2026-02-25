class Aic < Formula
  desc "Fetch the latest changelogs for popular AI coding assistants"
  homepage "https://github.com/arimxyer/aic"
  url "https://github.com/arimxyer/aic/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "1beae995886f56c54c0cfe08a800cdcf304df0dad6819312181415423a905ad1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eb51131c079fcfc58eb754bc2a2284aed10dd91eb7b9a7eeb68ec18b865303a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eb51131c079fcfc58eb754bc2a2284aed10dd91eb7b9a7eeb68ec18b865303a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eb51131c079fcfc58eb754bc2a2284aed10dd91eb7b9a7eeb68ec18b865303a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccd8fa4ce61f654c209622a1f7cfb24963a1e2e02473550957ff6fbb2aad7f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4601b3b66cde1a4e12eceabce1adb698028120859ab18707e8d028736e04bba3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aic --version")
    # Avoid network-dependent changelog lookups in CI.
    assert_match "Usage:", shell_output("#{bin}/aic claude --help")
  end
end
