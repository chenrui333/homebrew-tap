class Kat < Formula
  desc "TUI and rule-based rendering engine for Kubernetes manifests"
  homepage "https://github.com/MacroPower/kat"
  url "https://github.com/MacroPower/kat/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "770b6849498ae0d174bf01226a745e84ecb62291be2cb79642b512e97b9c271e"
  license "Apache-2.0"
  head "https://github.com/MacroPower/kat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54dcccc6743e86b5719d0d5eeeb5afef08952c99ef4ad99039e1a0fedfed655f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54dcccc6743e86b5719d0d5eeeb5afef08952c99ef4ad99039e1a0fedfed655f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54dcccc6743e86b5719d0d5eeeb5afef08952c99ef4ad99039e1a0fedfed655f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1710b2327d146c2fe12eccc8b014a560921325474f18397a0661a7bc4c16581a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f77d99120d90c79d84136c42abe8ac4d37ebdf6ec756de5f38a273c11d9b7b"
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
