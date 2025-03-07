class NhostCli < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.3.tar.gz"
  sha256 "78b7de0ecb9de12f687320ef4d255f1c16b2d97ca9395468f0102374ae5ba681"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "623795eefa59061d552ba67b331a6307a0358d2fe8dcee02aed8479003156d2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c834b0408b5f03e793d1faf6ffb3f09ad6f948d4353024ad7266254e4077fcc"
    sha256 cellar: :any_skip_relocation, ventura:       "0841a06a7d01a77011f0b9cafaa734481f176bf290a9811a33076dfc46b1d5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70c5371e02c3af69d4da62cc72e823dd71ace85cbcfff4193bbc8e2d4027e7f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nhost")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
