class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "6fbf71e896cd8ced1073c7eee51317686e63e5da13a369fd20cd3de34411c9cc"
  license "MIT"
  revision 1
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4119fec6400948b762504a00deacb5c07e72b8bb176f122023baf5a68f01fb31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d3579472cc922fd5efdc20f7e97d0ad3359159aef7393b505ad20781e1680e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e96511b76742c745a44888dc81395088aeee0c735a167701598fe99b905d138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aba4f034efc3d4d3a3acfd6f1f20b25b84c29fa66a05a068cd2af01afdd97aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e96bb6c57e0704cb366338783f96f5da326d070e57e4458304d3c898c746260e"
  end

  depends_on "rust" => :build
  depends_on "openvpn"
  depends_on "wireguard-tools"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vortix --version")

    config_dir = testpath/"config"
    (config_dir/"profiles").mkpath
    (config_dir/"config.toml").write <<~TOML
      log_level = "info"
    TOML
    (config_dir/"profiles"/"demo.conf").write <<~CONF
      [Interface]
      PrivateKey = abc
      Address = 10.0.0.2/32
    CONF

    output = shell_output("#{bin}/vortix --config-dir #{config_dir} info")
    assert_match config_dir.to_s, output
    assert_match "Profiles:    1 (1 WireGuard, 0 OpenVPN)", output
  end
end
