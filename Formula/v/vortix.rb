class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "2ad10a08225b9eb7069234f41aa3f719d7cc8fbaae6202cc3f34250ab74f1da2"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d4988a83ebc678a7e11b4bb5f93b13a6c929efffece1c9498f20aea9ebcb147"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fe55eb253fb192815c4f2ae8dc0cf2febec38821d0d8575e0441cea220f77e5"
    sha256 cellar: :any,                 arm64_linux:   "055c5a45ff460aaaf2ab05e2d76e77c7410d5c4eda52190289dfc84d9257af8e"
    sha256 cellar: :any,                 x86_64_linux:  "fc973b9125355475a9b4e01b45bbd34f2c5f7221a809f3d410b34de4bef5700b"
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
