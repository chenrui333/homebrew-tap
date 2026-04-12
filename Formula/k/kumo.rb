class Kumo < Formula
  desc "Lightweight AWS service emulator written in Go"
  homepage "https://github.com/sivchari/kumo"
  url "https://github.com/sivchari/kumo/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "610a26a551e652521635b281ee9251829ed6566c20ed436bc57dde9189a0fcd0"
  license "MIT"
  head "https://github.com/sivchari/kumo.git", branch: "main"

  depends_on "go" => :build

  def install
    (var/"kumo").mkpath

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kumo"
  end

  service do
    run [opt_bin/"kumo"]
    keep_alive true
    working_dir var/"kumo"
    environment_variables KUMO_DATA_DIR: var/"kumo"
  end

  test do
    log_file = testpath/"kumo.log"
    data_dir = testpath/"data"

    pid = spawn({ "KUMO_DATA_DIR" => data_dir.to_s },
                bin/"kumo",
                [:out, :err] => log_file.to_s)

    begin
      15.times do
        break if quiet_system "curl", "-fsS", "http://127.0.0.1:4566/health"

        sleep 1
      end

      assert_match '{"status":"healthy"}', shell_output("curl -fsS http://127.0.0.1:4566/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
