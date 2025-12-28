class Kat < Formula
  desc "TUI and rule-based rendering engine for Kubernetes manifests"
  homepage "https://github.com/MacroPower/kat"
  url "https://github.com/MacroPower/kat/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "770b6849498ae0d174bf01226a745e84ecb62291be2cb79642b512e97b9c271e"
  license "Apache-2.0"
  head "https://github.com/MacroPower/kat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b277899e0490cd7f5088c0c7f3b3d770f193486c18dd82aa51258f5e4185bb1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b277899e0490cd7f5088c0c7f3b3d770f193486c18dd82aa51258f5e4185bb1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b277899e0490cd7f5088c0c7f3b3d770f193486c18dd82aa51258f5e4185bb1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "971fae500cacec07c2530b6e84ee48c9af08fabe3154fbe433681bb22a2cf293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0c7d3ee1e63e2d3dda5ba3fdde33b622cc881d483acaa14c79b4cfdcf712fa"
  end

  depends_on "go" => :build

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
