class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "6e9b3bbaea6aba094b8915c4806e1722e9eeaf4f075695b08a348b79be12292e"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8902e3de61f9f013bcc22352756dbf893afc82e06c40c63c40e88529670ec93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8902e3de61f9f013bcc22352756dbf893afc82e06c40c63c40e88529670ec93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cbf11effe72de968d195feabb9353ead4c57ec4cb191ce03accca5f11e3ce1d"
    sha256 cellar: :any,                 x86_64_linux:  "4844cc144db25c489498c57bdcf40fd3ee65e6589f610d6552318c035abb4cd4"
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
