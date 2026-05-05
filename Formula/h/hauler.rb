class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "722ac64d97483716ad9c95a7f63387244db7e91096aae738739f7858c2c83cf9"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e2cb4bb7626e4322b1114d9303e88672af9019d7a37b2a828e33c49abe649d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e699fdabd63570f84d0c7a7bc3621f060addb15bc38ee633919f28668e64b82b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db9f2616d2ed05571484e34488982aeb3a0a9c1deabf8385bb8651f92853ebaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8dc727406557ad81a1339e4e427f9fbbdff4ecd80a10f064c32200f71ee673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89117764355f8961e884096f0fede232d2d3f2d445392d20bad4a8ecf64d2daa"
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

    generate_completions_from_executable(bin/"hauler", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
