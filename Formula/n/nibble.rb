class Nibble < Formula
  desc "Scan local networks from a terminal user interface"
  homepage "https://github.com/backendsystems/nibble"
  url "https://github.com/backendsystems/nibble/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "5c7bc47d86847009f686adf3f7db27e9589ebe31f567c4dcbcf64834f4975910"
  license "MIT"
  head "https://github.com/backendsystems/nibble.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6881f72ce891c010d6236b79c6b7accf9ad27b80c293fd030a69498736aff08f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6881f72ce891c010d6236b79c6b7accf9ad27b80c293fd030a69498736aff08f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6881f72ce891c010d6236b79c6b7accf9ad27b80c293fd030a69498736aff08f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81f8087cc1f7a8ffccc6e214f7ae6dc5973c02cf7e4c75e6c843ed474fe8b11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca1123784c0980aee51e6819cd18be63907999ecebd394ea5e21c16e72bf7bb"
  end

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
