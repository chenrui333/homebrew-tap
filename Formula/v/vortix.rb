class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "d72136643c909abaacfd2470355fce518cc2db98f5290e2cf930b13443c07fee"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df39b3a44bd0c337349886766208110bcefda8bd08266317e050c9d9c17fb537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e35e4d813308dfbf2a2b36db1faa058f8e62a4a12c58bc145ab779567d8adf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c95c6ebed820d5ccc73106b784719afd6e05def9945453e582a757f344dec5c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d21c83f8cd40a30a0a8364940809549d7f60b84ad7698fb567da81500d8999ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3db37e090f5e0a8e3a8071793c7a32b9d7bc8b9aed4459124601a652e2c6cb"
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
