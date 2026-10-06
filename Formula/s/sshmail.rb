class Sshmail < Formula
  desc "Encrypted message hub over SSH"
  homepage "https://github.com/rolandnsharp/sshmail"
  url "https://github.com/rolandnsharp/sshmail/archive/89793373eadbb773906192dc2f886cd168b9009f.tar.gz"
  version "20260312.8979337"
  sha256 "9c787fb3e0c39861a7503391ae8593385b114ac4976ecace577598e0af89f4b0"
  license "AGPL-3.0-only"
  head "https://github.com/rolandnsharp/sshmail.git", branch: "main"

  livecheck do
    skip "no tagged releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a246577e6d6e42d14c355c9294f710db0919f9616028b76f2da92d3032ca3118"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a246577e6d6e42d14c355c9294f710db0919f9616028b76f2da92d3032ca3118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb1a2b126a2f249f8a763d0a18d252371464cfde7fa8b99e9a5a7eb5fc48accc"
    sha256 cellar: :any,                 x86_64_linux:  "8545af1c32633cd4e892e0dc3073891d51338d42eec835619b0508a4e6788dae"
  end

  depends_on "go" => :build

  # The test registers an account by SSHing into a local hub over loopback.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    (var/"sshmail").mkpath

    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"sshmail"), "./cmd/tui"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"sshmail-hub"), "./cmd/hub"
  end

  service do
    run [opt_bin/"sshmail-hub"]
    keep_alive true
    working_dir var/"sshmail"
    environment_variables BBS_DATA_DIR: var/"sshmail"
  end

  test do
    port = free_port
    ssh_key = testpath/"id_ed25519"
    known_hosts = testpath/"known_hosts"
    log_file = testpath/"sshmail-hub.log"
    data_dir = testpath/"data"

    system "ssh-keygen", "-t", "ed25519", "-N", "", "-f", ssh_key

    pid = spawn({ "HUB_PORT" => port.to_s, "BBS_DATA_DIR" => data_dir.to_s },
                bin/"sshmail-hub", [:out, :err] => log_file.to_s)
    sleep 2

    register = shell_output("ssh -o BatchMode=yes -o IdentitiesOnly=yes " \
                            "-o StrictHostKeyChecking=no " \
                            "-o UserKnownHostsFile=#{known_hosts} -o LogLevel=ERROR " \
                            "-i #{ssh_key} -p #{port} 127.0.0.1 register testagent")
    assert_match "\"ok\": true", register
    assert_match "\"name\": \"testagent\"", register

    output = shell_output("ssh -o BatchMode=yes -o IdentitiesOnly=yes " \
                          "-o StrictHostKeyChecking=no " \
                          "-o UserKnownHostsFile=#{known_hosts} -o LogLevel=ERROR " \
                          "-i #{ssh_key} -p #{port} 127.0.0.1 whoami")
    assert_match "\"name\": \"testagent\"", output
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
