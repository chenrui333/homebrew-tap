class Nibble < Formula
  desc "Scan local networks from a terminal user interface"
  homepage "https://github.com/backendsystems/nibble"
  url "https://github.com/backendsystems/nibble/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "6512975cea3233ca2ad6edcb61302d5bccbc0b75eb0e7048b86f1c5a8b22a573"
  license "MIT"
  head "https://github.com/backendsystems/nibble.git", branch: "main"

  depends_on "go" => :build
  depends_on "ruby" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/nibble --version").strip

    (testpath/"run_demo.rb").write <<~RUBY
      require "pty"
      require "timeout"

      status = nil
      PTY.spawn("#{bin}/nibble --demo") do |r, w, pid|
        sleep 1
        w.write("\\r")

        begin
          Timeout.timeout(20) do
            loop { r.readpartial(4096) }
          end
        rescue EOFError, Errno::EIO
        rescue Timeout::Error
          Process.kill("TERM", pid) rescue nil
          raise "timed out waiting for nibble demo scan to finish"
        ensure
          w.close rescue nil
          _, status = Process.wait2(pid)
        end
      end

      exit status.exitstatus
    RUBY

    system "ruby", testpath/"run_demo.rb"

    history_root = if OS.mac?
      Pathname(Dir.home)/"Library/Application Support/nibble/history"
    else
      Pathname(Dir.home)/".config/nibble/history"
    end

    scan = history_root.glob("**/scan_*.json").first
    assert_path_exists scan

    saved_scan = scan.read
    assert_match '"interface_name": "eth0"', saved_scan
    assert_match '"target_cidr": "192.168.1.100/24"', saved_scan
    assert_match '"hosts_found": 4', saved_scan
  end
end
