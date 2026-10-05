class Kat < Formula
  desc "TUI and rule-based rendering engine for Kubernetes manifests"
  homepage "https://github.com/MacroPower/kat"
  url "https://github.com/MacroPower/kat/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "770b6849498ae0d174bf01226a745e84ecb62291be2cb79642b512e97b9c271e"
  license "Apache-2.0"
  head "https://github.com/MacroPower/kat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "456281c8735477b742083bf9788934d1d84f26d38d71d040df1cbbb713575be5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "456281c8735477b742083bf9788934d1d84f26d38d71d040df1cbbb713575be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4405d8883f0ddbd0014c25f7b78a5075660320de30f4b6b8319afe01efd22970"
    sha256 cellar: :any,                 x86_64_linux:  "39dbe6bf6a573fed2bf25b6d97ff2dc1e44ad1c97e8973fd290a4570c2da098b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/macropower/kat/pkg/version.Version=#{version}
      -X github.com/macropower/kat/pkg/version.Branch=main
      -X github.com/macropower/kat/pkg/version.BuildUser=#{tap.user}
      -X github.com/macropower/kat/pkg/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kat"

    generate_completions_from_executable(bin/"kat", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kat --version")
    assert_match "profiles", shell_output("#{bin}/kat --show-config")
  end
end
