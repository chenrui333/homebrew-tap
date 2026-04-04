class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "12ad1807b9bb7a4f79f2305740d8a7751d2edb95878ab2992f4a21033ca74161"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8819a2bab0dbb75885891cb2896eeac1130d40699165ccfe2c53537b8f8e8fab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bacb88f865efc8cedf84bc0af45d23e76f2773f0749ad43a4452bc21f747e2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23860c481823321084aac79bfef96e987e92e043e7587420553c872e3b72c33b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9b3136b5d7bfddd3738a726d8d5e0e20714d3b6d556853c93e50d9e58beb024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52599908df2e84a8653f0d9c59a03e3c74d9457cfecddbf281e464d5569191bc"
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
