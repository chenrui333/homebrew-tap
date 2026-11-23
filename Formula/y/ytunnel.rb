class Ytunnel < Formula
  desc "TUI-first CLI for managing Cloudflare Tunnels with custom domains"
  homepage "https://github.com/yetidevworks/ytunnel"
  url "https://github.com/yetidevworks/ytunnel/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6cdfb9ca42866640afc7ddd6b4cc5beb0688cd664e6fc87969b95bda9245a9d4"
  license "MIT"
  head "https://github.com/yetidevworks/ytunnel.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytunnel --version")

    output = shell_output("#{bin}/ytunnel list 2>&1", 1)
    assert_match "ytunnel is not configured", output

    config_dir = if OS.mac?
      testpath/"Library/Application Support/ytunnel"
    else
      testpath/".config/ytunnel"
    end
    config_dir.mkpath
    (config_dir/"config.toml").write <<~TOML
      selected_account = "work"

      [[accounts]]
      name = "work"
      api_token = "dummy"
      account_id = "abc123"
      default_zone_id = "zone123"
      default_zone_name = "example.com"
      zones = []
    TOML
    assert_match "work", shell_output("#{bin}/ytunnel account list")
  end
end
