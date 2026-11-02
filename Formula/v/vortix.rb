class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a3efecbbb882ba2f985f9dd7d29accf5e9c521be7cfb1bf8bee18707897ed691"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c49825fbcbfe52b94fadc0799fc99793f33fa04b03e99ccc847af061d0e53eb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3099a5d848c67b58b68e9ecedc7cd413f2f978c37423c6ece3c4a408253450d1"
    sha256 cellar: :any,                 arm64_linux:   "f2196387e5793df392a7e6b73868c0bc6c1cdc952ae19efcb9cfc14fd8e60811"
    sha256 cellar: :any,                 x86_64_linux:  "fd96ee6dca0a36492ff3afa142b648f96921e32f50e83ac98f311bbe4e2306dd"
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
