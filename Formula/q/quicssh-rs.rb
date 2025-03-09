class QuicsshRs < Formula
  desc "SSH over QUIC"
  homepage "https://github.com/oowl/quicssh-rs"
  url "https://github.com/oowl/quicssh-rs/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "1e1b98e67598e2ee1c3704c75072b9e120a0ec21f70ad2cd1d2c5918d68a57b8"
  license "MIT"
  head "https://github.com/oowl/quicssh-rs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa78c85e190567d925be3891c725f4ac0f6785b6241c18350ca30d31eeea214c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6993f02cdb1ad724096826baef61426943418d5bd3a98fc8eb837bc859decf88"
    sha256 cellar: :any_skip_relocation, ventura:       "e5d1b33bc170d4a97738e386a4ee8ead401739902f7bed07c3292206601dbd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aee3e87ada694937fc86f8b1ea3679c25144d128bfa5fa9a929b380ab5a59c7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quicssh-rs --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"quicssh-rs", "--log-level", "debug", "server", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "[server] listening on: 0.0.0.0:4433", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
