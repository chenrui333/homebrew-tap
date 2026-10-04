class Headscale < Formula
  desc "Open source, self-hosted implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "cb38683998d13d2700df258a81c00add199dccb999b1dacc4491305cdaa67db3"
  license "BSD-3-Clause"
  head "https://github.com/juanfont/headscale.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e641e5064903006b382056bc56698c22504734a3dd2980e267da41d8b6b4d056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12d0c96ac66dfa358543d2908f43ed78dbcc85e5891dc32be095ba694a9bd570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e37c036cff7342524ff3b6c2e11cf5996287c76d3c3e828b74e412fc6c1b84ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40572ebbf8a019b34c16e2b76cc696266eb64946b7dabb9aa2fcf7d787df6c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603d532cb84698237c9df7a7f027c2ee1b647b00e39046c8248022b7df206e41"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # TODO: Remove when a release includes Go 1.27-compatible go-json-experiment: https://github.com/juanfont/headscale/pull/3505
    ENV["GOEXPERIMENT"] = "nojsonv2"

    # Version comes only from module build info, which is "(devel)" for source archives.
    inreplace "hscontrol/types/version.go", 'Version:   "dev"', "Version:   \"#{version}\""

    system "go", "build", *std_go_args, "./cmd/headscale"

    generate_completions_from_executable(bin/"headscale", shell_parameter_format: :cobra)
  end

  test do
    ENV["HEADSCALE_DISABLE_CHECK_UPDATES"] = "true"
    assert_match version.to_s, shell_output("#{bin}/headscale version")

    config = testpath/"config.yaml"
    config.write("server_url: invalid\n")
    output = shell_output("#{bin}/headscale --config #{config} configtest 2>&1", 1)
    assert_match "server_url must start with https:// or http://", output
  end
end
