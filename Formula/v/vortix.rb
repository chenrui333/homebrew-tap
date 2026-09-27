class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "65d7ba9be74d538833113c488fb9a94aad1f11413ccdf0fc3087dd8bfe835125"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f3119bffeebc6c38732031750fe9de94eee574238a6647648698653c8b42274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bef1bc6a7b669f114990c2e5bd0f24f3a801d555c950e9c1352b9ecb97aa185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fffc355b702fdd1a934cdfa8a60b2ce27025418645f56ae1b1f8873e171fe727"
    sha256 cellar: :any,                 arm64_linux:   "42a5b449b9fbb8302fb8d7bdb67483789406a2d8ea408f816b1bfa0db223ee0f"
    sha256 cellar: :any,                 x86_64_linux:  "15c9696cad1b378d4145947afbe1da71656e049b6ec32eecd5c80577787c4f93"
  end

  depends_on "rust" => :build
  depends_on "openvpn"
  depends_on "wireguard-tools"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/vortix")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vortix --version")

    config_dir = Pathname.new(ENV.fetch("HOME"))/"vortix-test-#{Process.pid}"
    config_dir.mkpath
    config_dir.chmod(0700)
    profile_file = testpath/"demo.conf"
    profile_file.write <<~CONF
      [Interface]
      PrivateKey = abc=
      Address = 10.0.0.2/32

      [Peer]
      PublicKey = xyz=
      Endpoint = 1.2.3.4:51820
      AllowedIPs = 0.0.0.0/0
    CONF

    system bin/"vortix", "--config-dir", config_dir, "import", profile_file
    output = shell_output("#{bin}/vortix --config-dir #{config_dir} info")
    assert_match config_dir.to_s, output
    assert_match "Profiles:    1 (1 WireGuard, 0 OpenVPN)", output
  end
end
