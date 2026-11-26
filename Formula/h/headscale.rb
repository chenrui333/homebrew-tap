class Headscale < Formula
  desc "Open source, self-hosted implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://github.com/juanfont/headscale/archive/refs/tags/v0.29.8.tar.gz"
  sha256 "77dcadd5e9f6620a20152508af38d65e61aef2c9977bdc031d76db3355e54300"
  license "BSD-3-Clause"
  head "https://github.com/juanfont/headscale.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "667f57127da6930bff375c181b3ecdd6704088f240ea31c403164d065194c89f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a05ebc42485aaff2959eeccdd88e275e003dfbbc6b3adb841c73719aa573747"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71c2fe6797fdab91871cdda2b6c92b405a895736b354002afeeff057bd657163"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3193ab9a9577c6a534a217fe0d722ac96df296e75b3c8398db20afb2f044b9b1"
    sha256 cellar: :any,                 x86_64_linux:  "5f8c5ed6041cd3f51dc88cec23abae3b730ef50d01eb4e174c62786bdefc8a14"
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
