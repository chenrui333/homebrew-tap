class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "7a1b14c3c8902270eeef8ed4308d7600643ba7121cba73b9aa5b00bd8e9a35fe"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aea1f0c47c93360377a8d502d6858f8ddfb779d184088a4e469f1a594d40aeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17c499c193906a00d98b48f6e89753fb6436bb7f8a775dfd1f456ec6ba103167"
    sha256 cellar: :any,                 arm64_linux:   "56b3fbc0ea1ab0a011073ca0f008701e685bc429cf185e12c33b6623f99468a0"
    sha256 cellar: :any,                 x86_64_linux:  "3f14a0012cdbd1700681cbac3cf6887e2fcfbec2dd00bea18f0ddc09e68b3451"
  end

  depends_on "rust" => :build
  depends_on "openvpn"
  depends_on "wireguard-tools"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
