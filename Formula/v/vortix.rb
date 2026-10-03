class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "7a1b14c3c8902270eeef8ed4308d7600643ba7121cba73b9aa5b00bd8e9a35fe"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc08d41e4333b0e99164f5a042b3577bb66e5e54faeb129eff1e0943269390c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5877eac2f6c619e470c85e7308c1ef7cd40f2219ecab488a950cedf2fcf91ac7"
    sha256 cellar: :any,                 arm64_linux:   "a736cb836cce84a2c757e5798a66e3ebb24daf0c51eb78c0f3a4fe2b47f839c7"
    sha256 cellar: :any,                 x86_64_linux:  "0ac13ef44cd35eec6a87d87a211d18300ec4fb1cd06a433bd7eaf88ade02d3e1"
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
