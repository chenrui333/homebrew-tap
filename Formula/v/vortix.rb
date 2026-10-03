class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "816a4b957c843f9eb9025124f0d4a400167c4fec6fcdd2d09855b5e674e1f244"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f3fb2a50762db7a9c05c6c4918754a6a76b37811a2f7eaf39cfae844ae22944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d0c4cfc9a39c39784f5d60a5000e658b3daac07d24bbbbe91e69a87426429bf"
    sha256 cellar: :any,                 arm64_linux:   "8f68fda9a0b5ded1806fe4f498bf6da728f7f8e27067928d618dd045f95132c1"
    sha256 cellar: :any,                 x86_64_linux:  "6bc74c9aa8be0c06be581df2b545954e87bf377260d6c073835a23364b14e011"
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
