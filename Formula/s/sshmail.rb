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

  depends_on "go" => :build

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
