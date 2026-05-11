class Nibble < Formula
  desc "Scan local networks from a terminal user interface"
  homepage "https://github.com/backendsystems/nibble"
  url "https://github.com/backendsystems/nibble/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e3b084ddfacba6b9af9a004d7f6205495e862652b63d9bd96950990d3e610ec5"
  license "MIT"
  head "https://github.com/backendsystems/nibble.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e17b236b4fbe394ad48b56c7db07ceae43fd9c1fe25137097ef2116f0ef1a83f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e17b236b4fbe394ad48b56c7db07ceae43fd9c1fe25137097ef2116f0ef1a83f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17b236b4fbe394ad48b56c7db07ceae43fd9c1fe25137097ef2116f0ef1a83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8aec5bf1672fd8b7fa086202fa9598d799704e587089590f20fb2fff9db1431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db53192f7b417796e4dd3e9c5174c1619af095220e083f2fa8e20a7f7988ac8"
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
