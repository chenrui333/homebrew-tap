class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "3b68915d5bcfc534620a37386ed6f3124077858591fa34d0f9908adac2436bfb"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a474e7cd4b350887faa6a38ddff8bcd68500d373d017ce117be155d68d56145b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a474e7cd4b350887faa6a38ddff8bcd68500d373d017ce117be155d68d56145b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eed599c8c61117e24a46a7c928beac357c5b2973066fbec85af2782da3e27d6"
    sha256 cellar: :any,                 x86_64_linux:  "9307c5c6696f3e70c692d7677225f4fe1301d559bfee471d70179fca092a79b1"
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
