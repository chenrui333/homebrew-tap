class Headscale < Formula
  desc "Open source, self-hosted implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "8a19bfaaa1533ab69b63e9cef4658758aad79dadd43088c6cc7313ab88df7de5"
  license "BSD-3-Clause"
  head "https://github.com/juanfont/headscale.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/juanfont/headscale/hscontrol/types.Version=#{version}
      -X github.com/juanfont/headscale/hscontrol/types.GitCommitHash=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/headscale"

    generate_completions_from_executable(bin/"headscale", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/headscale version")

    output = shell_output("#{bin}/headscale configtest 2>&1", 1)
    assert_match "error reading config file: Config File", output
  end
end
