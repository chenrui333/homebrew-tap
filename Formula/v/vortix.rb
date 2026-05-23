class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "9bdfa44776d61c31d392971c7374220bd1dce59586ab46b72a2e40cf5c03b2a1"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad3eff9f18b449af5815433cfae424baf275c3569cb06141c5da094d3f18ff1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90612c87ea759c23eff61b0f038ef32bdaac406f1a5c7e1b5425eb532066e1b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56a9c9467d6ad6ba2645bca9189cc8578b5b0956b8d0b6bbdc32a018897f34ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f67572ad94b4c5d222e362ea4b7299450f267b022fd2facd677e68e2f8a1583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b8f0beb89d162bf1c629f8c817fedf702da0d44ac6d5524bc1b5c89e2a33b80"
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
