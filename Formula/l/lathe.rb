class Lathe < Formula
  desc "Generate hands-on, multi-part technical tutorials on demand"
  homepage "https://github.com/devenjarvis/lathe"
  url "https://github.com/devenjarvis/lathe/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7a0b220e10009c5dca0517392d893df02c6df96fcc8f8fd261b0713a6fdea262"
  license "MIT"
  head "https://github.com/devenjarvis/lathe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "51e055c7e3c8c896f5fa5cb99609b5fdc3addeb8f61ff7b7cf02f0225bb2825b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b08dd98e7a9ae89a35171ee84c6fb1d5ce41da8662f86c60ff102fd0f57f52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3b08dd98e7a9ae89a35171ee84c6fb1d5ce41da8662f86c60ff102fd0f57f52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2e9f52a4f9390a006e1a8bd0e2de3ee7af8864f358d398c3064291be919ecef"
    sha256 cellar: :any,                 x86_64_linux:  "ebf479bfe93aa0af7d9e162e486fefdf7881c4e4ee8f05a3cf15ecce702cc986"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/devenjarvis/lathe/internal/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lathe", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lathe version")
    output = shell_output("#{bin}/lathe not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
