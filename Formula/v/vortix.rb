class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "d72136643c909abaacfd2470355fce518cc2db98f5290e2cf930b13443c07fee"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1ff59828c2912c4d80e2cf10f578c2346ee1ecd0051781759b262c1b7fe2df8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48f74a01b3e19a3ab0b876faa3dd9f1f27a66e3abd838e680829df41916b525b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f5718d5564f2f5fbf8f485e6774f7c765bfbf4a17f51f6e9310e92800bfdb89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3a6889136c0fe923c3a81a881e4935ca8d933276636d8f1fcec305e2e5e2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a353df7e64ac35b742d23e74905d3e4df1316cd0f17c82667db7a8b65181912"
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
