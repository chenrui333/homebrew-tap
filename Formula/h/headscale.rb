class Headscale < Formula
  desc "Open source, self-hosted implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "8a19bfaaa1533ab69b63e9cef4658758aad79dadd43088c6cc7313ab88df7de5"
  license "BSD-3-Clause"
  head "https://github.com/juanfont/headscale.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4fdac09e2fd3525e5ee2c6d0bcb20f24c521d04da9cd2ffae5739a4dbc2aac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c3f6cdb74a6b0530b5dcf829d0a026c881efe25400dfe4f181e3012beff0f48"
    sha256 cellar: :any_skip_relocation, ventura:       "19ebfb927544491413f730982e8b61d899255004af20190832033603acc2e98e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acf4012403e094eebd33ffcabe26ac308f6de5e0ee6a78ae7fcfe49b6c43ff37"
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
    assert_match version.to_s, shell_output("#{bin}/headscale version")

    output = shell_output("#{bin}/headscale configtest 2>&1", 1)
    assert_match "error reading config file: Config File", output
  end
end
