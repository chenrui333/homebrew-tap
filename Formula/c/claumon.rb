class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "702de999de5cd7c648896ea8f75b285fa6ecd1704fa4189d45ca161ac6c28cf2"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23bd4673047319801fe6284a1875ebcf420775e6a05774b63261097332b21557"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23bd4673047319801fe6284a1875ebcf420775e6a05774b63261097332b21557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23bd4673047319801fe6284a1875ebcf420775e6a05774b63261097332b21557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20779fa996c44e150f8a7aee21ed11a411a688f172e7778c60c990041a53d2db"
    sha256 cellar: :any,                 x86_64_linux:  "5c18aac329881e66d03d12112bb1b89fa459a339773adc7a1fdb3b54d6cf7900"
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
