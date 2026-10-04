class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "d947d36b79ab37ad505e17d7bb88a86751effcb3cb05b2d844ffefc092edeb78"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caa63e63064938e9d6599952e103cf09b88add7feeb5e7fcceb1272a92d5d5a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce7558679737a02a63fc7324fa1f7a9544b5f694f547caa8bb675acac33ce048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677b5f6aad8a2a01df684cdb52efc936f96594b4872fb6a264783740158ace0b"
    sha256 cellar: :any,                 x86_64_linux:  "bb2207578c6bd7d10c298470f8fe166ba6b1b086f14b25837be0855f2aa54636"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/v2/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/v2/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/v2/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/v2/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
