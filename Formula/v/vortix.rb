class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "108ca9cbd0326fb4fde1e3e62e6dda5903859e47160d9420d8109f36602d3ee2"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "569e1a0a13e1e161569316190064d4dd9ef3aa68dfe19e8a8f57362f24c6a1e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e41e04dcf7913541c902d4db9b2e7e3ff987fe493233b01f838dd2f1fc1d1aea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8cf8f9d2bc398e02cedaf3f9c5c0e04c4373d34f929062b264d5fe02951698c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "418ccb7fa442dcadf22651f304973f5fd31217f45fbeb14ccc6c26a973429e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39e77b0f471603ebf63f1cfa3611a7b10faff44d13ba0dd8b12790b159e6c429"
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
