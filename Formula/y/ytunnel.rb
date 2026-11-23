class Ytunnel < Formula
  desc "TUI-first CLI for managing Cloudflare Tunnels with custom domains"
  homepage "https://github.com/yetidevworks/ytunnel"
  url "https://github.com/yetidevworks/ytunnel/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6cdfb9ca42866640afc7ddd6b4cc5beb0688cd664e6fc87969b95bda9245a9d4"
  license "MIT"
  head "https://github.com/yetidevworks/ytunnel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "b8010d5ebece7859bc0e4ab472504b83e45643be7082dc1f446af37f3a29f6eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7f19df93fa226501b43ad760138a8f5fa4abd6f34b2b4eefdb0567abc4cc9fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6cfa54cd23d7d4f1912d4872cf199d4fede6a1312ffc9de25c73fb5f64e3815"
    sha256 cellar: :any,                 arm64_linux:   "e2b533bf68fe5bea926e065f10097861ae6c8747b03bab9958e72e34e0ad8d46"
    sha256 cellar: :any,                 x86_64_linux:  "294ed501c8d0730a5effdf259b5afeba892481b61e54f0fd8602cc2715d492a2"
  end

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
