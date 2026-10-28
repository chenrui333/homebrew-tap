class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "77aa5202547a52873f591451bf8818a0965315eddab18de2f0317e90be7bc04a"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "406de1dbc60571b5ae46850e6885dee7249760d7efd876be58957e3cacac565e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406de1dbc60571b5ae46850e6885dee7249760d7efd876be58957e3cacac565e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "299659c233f007ce22f0949f359e48263110b352f447f481a1b51eaf8d7f1653"
    sha256 cellar: :any,                 x86_64_linux:  "8e6cdd28cfe3c07d968f949e2ace19e42e0f88b722983b6912b456cff1880421"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"claumon"]
    keep_alive true
    working_dir var
    log_path var/"log/claumon.log"
    error_log_path var/"log/claumon.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claumon version")

    output = shell_output("#{bin}/claumon diagnostics 2>&1", 2)
    assert_match '"diagnostics" is unavailable in this build', output
  end
end
