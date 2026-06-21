class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "fa5bcaa42b565c34b33cfba1b55e73440483799e6a68b4fd3d313341cece26f8"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "306568b77fcd3f9bd95da7d3adc718c4c7ff21cf1c94592db5f73084523bc772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306568b77fcd3f9bd95da7d3adc718c4c7ff21cf1c94592db5f73084523bc772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "306568b77fcd3f9bd95da7d3adc718c4c7ff21cf1c94592db5f73084523bc772"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a492916897e2112fe6df5793c323994852e343848ac832056ef5e01f5d242a28"
    sha256 cellar: :any,                 x86_64_linux:  "ea05572a75c663bc92e2dd77b498f7ffc93623cb0df798aebcf7729daac69458"
  end

  depends_on "go" => :build

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

    port = free_port
    pid = spawn bin/"claumon", "--port", port.to_s
    sleep 2
    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match(/claumon|dashboard/i, output)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
