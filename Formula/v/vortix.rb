class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with real-time telemetry"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "680d4a5456be0bf7875ed65c36798db751c8ad1cbbcfa81b6ec714845ec311ec"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "273c4c219a501463fd9f96eda115c183281855e651aaecdcbc8cac001f21ebe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "615ee83b86c3cfaa9131073adda3ee590f695bd26df8ecfbd783293699a0fd8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "621713791b7ddef81d3f86279482e50c35605bfefab9490370b7b7fa92adce3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f94b0393f852a337c1aa937fb8dfc541a3e479a454f675f23014a8a1a6f1e4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c37b3577810fc7f48d8b3c7489f850c9e88c17267025b22657d698a28b8f94"
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
