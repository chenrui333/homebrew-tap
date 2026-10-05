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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f92cb41298571861e0cdc121ae2c53dc7b78ec4a912f11f569621153720b1ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65a560fd2fd7e4b55d110be4dd88d7006fc3c5bdf2cadf22ae8f8db0dc8a92de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70510eeb8649d3cab6985f9262c6d7b23bec268d9424974804be2755a6a4f5a0"
    sha256 cellar: :any,                 x86_64_linux:  "a864e67c5e519f10bf2c768465e0610c98567fce0d2da70eb6001253af770888"
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
