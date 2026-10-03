class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "7a1b14c3c8902270eeef8ed4308d7600643ba7121cba73b9aa5b00bd8e9a35fe"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba16d5717a5e0b2bdbe6f237d6e3c5d8bd9730034b331dd92f7d073134dea790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08c550c4c5c851230237043cc36f0b3ea9da6ccdb0000049e6bff08570834254"
    sha256 cellar: :any,                 arm64_linux:   "96f69b9e8dfe6e75d919f043efb0806b08c532a5a724f22702ac677bdb767115"
    sha256 cellar: :any,                 x86_64_linux:  "cdb6b18f0dc9f7f4eae86f552b0dc09c24a6bee2cca41d9d6947664ff03e90f7"
  end

  depends_on "rust" => :build
  depends_on "openvpn"
  depends_on "wireguard-tools"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/vortix")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vortix --version")

    config_dir = testpath/"config"
    output = shell_output("#{bin}/vortix --config-dir #{config_dir} info")
    assert_match config_dir.to_s, output
    assert_match "Profiles:    0 (0 WireGuard, 0 OpenVPN)", output
  end
end
