class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "2e5f4c0c2bdc104c4d20a5714dc482029b88eb26cae431d6ce2d3d3f2aab08f7"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dbe5793fd3c6b1dc1428afb66c30c0a177fbbf5c6bcfc51a8b6124b8eef22cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "198886956e2803b0c632a6e9223979f04bdf04e3a5c4904aa03b476b57d3062e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29a4db21753410d118453ac71870f891e132d9c7de6c16011b192f61190a45ff"
    sha256 cellar: :any,                 arm64_linux:   "697c0fee96a0c087612e40d621544b6af246fd7f4d6c18f71f4659cae5361cf8"
    sha256 cellar: :any,                 x86_64_linux:  "9e078f8b8bc9738e4754886c93626e177917493e12111bd5b7da5b24a59bb81a"
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
