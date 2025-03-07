class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "ea875e49968ca4bdd0f5ac2a78c3f6932b75619b647232a554b5b973e42d3317"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5374357a17b7473ae83be8cbc61f886a5cbf662a34cb2d61e42465e54759436e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe730ef11fc3ba5b03ce69a87174ae2a0ba93f4557d702a54aeae0103809b4a0"
    sha256 cellar: :any_skip_relocation, ventura:       "97cdc11538f19aec1904df57241ea63bcba101ec5b4d1ccedc3c1b6c7d4d9448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e4547ead52f0c3078cff08e417a3fdf0852223b53ea0f32bc243a92f9b1f25b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
