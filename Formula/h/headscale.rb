class Headscale < Formula
  desc "Open source, self-hosted implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "cb38683998d13d2700df258a81c00add199dccb999b1dacc4491305cdaa67db3"
  license "BSD-3-Clause"
  head "https://github.com/juanfont/headscale.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "886c586fbd379855a4d66b77c04b460016fd1645fcb92129a93a0d31d859cb83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1694ef1c0108c888b87adfb84d1d171360125ec8d0be3317e07819b22d6cc0f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcfcf9c6a3206372bffd0c45b0af51ccb74cda20148c4feb098c179b8c65ac9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f5249c103aa9f692c7c5bcd80a8e0bda11e920f9ab524011c034b637880a391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150b724109ddd0435b3ddef4c97182169dbce8681c2b9642093fd0fa9a31457c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/juanfont/headscale/hscontrol/types.Version=#{version}
      -X github.com/juanfont/headscale/hscontrol/types.GitCommitHash=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/headscale"

    generate_completions_from_executable(bin/"headscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match "headscale version", shell_output("#{bin}/headscale version")

    output = shell_output("#{bin}/headscale configtest 2>&1", 1)
    assert_match "Fatal config error", output
  end
end
