class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "3f533f90c912df5a2a162192212cfc9fe414826ffee8975c9e22df66445e90f2"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9de60f9d302d096b20d736addcd58399b3fa524495076a83be5c0e7d4159d962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdd4cde417560a1ed708f8d727bb374d62c5e07acb36d6b57516c44301d5429d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a235571d46d463081abd15f54e3691e4d46949bce21064d52828ceeda4299a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2bc99278d82d49debad0c1e874fa278a6b0731ea06806b89dd18753ffaa9284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7fd2a493cb76157ea502ac876dc165f5b870bed8f8246758e53c21ad59ba6c"
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
