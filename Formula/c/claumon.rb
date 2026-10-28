class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "77aa5202547a52873f591451bf8818a0965315eddab18de2f0317e90be7bc04a"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70c63704fd3877fac6446bd368170019c820aae5be2acf13a9af93d20f4cccb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70c63704fd3877fac6446bd368170019c820aae5be2acf13a9af93d20f4cccb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7e0309bcfb2ca732d98ef2aa04113e54138b7d112abc11f57d7f420c745da9"
    sha256 cellar: :any,                 x86_64_linux:  "e48fc96ec4a7b68cd47ff018205e7d9a92bf18dcbe3fea0f14cc938692ed397a"
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
