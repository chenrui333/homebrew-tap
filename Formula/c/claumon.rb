class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "019867949a3a9b1464dd2c44e21f3178863211494d40d8fea1c289370d41e327"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca871dc5bd1c57d005427c0c61ec1ec4b6cc69eaac86d8252e460dfe4e6814b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca871dc5bd1c57d005427c0c61ec1ec4b6cc69eaac86d8252e460dfe4e6814b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2121a1ddac427c9d610e24d0c7228448df2589cce6bcdfceeaa172c2fa28a238"
    sha256 cellar: :any,                 x86_64_linux:  "e8bd1b533439fe9b4eb055bc2d8afb7f0b07c62ef1155048dd87fe1b2e119bcb"
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
