class Chock < Formula
  desc "Sandbox-first AI coding harness"
  homepage "https://chock.ws"
  # Pin the snapshot commit rather than relying on retention of nightly tags.
  url "https://github.com/LilithSemi/chock/archive/ab0600ebb870421d9838855d12e6cdeb683a0f8f.tar.gz"
  version "0.1.0-unstable-20261031-ab0600e"
  sha256 "efc4f71a1383a4e27d9e77094cfdeb8040e500243b0bfc64acbb425e949568ff"
  license "Apache-2.0"
  head "https://github.com/LilithSemi/chock.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "978a528e2255bd85ca2c176dd2a6f4eeae334522a9590e8c959caee8263cbf3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425f4c53b0ea32da3f16b517c3c99be5975f860c6fdd680bc13e922e3d919742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee5eea97763398b32d38c1b187f095690da3b4112a8b75dd302fcbfa6927a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9df17ec22fcfef2b9a624458002ec172119ceb1623d931febde4365428578f0"
  end

  depends_on "typescript" => :build
  depends_on "zig" => :build

  # An explicit allowlist denies other phases; only the loopback fixture needs network.
  allow_network_access! :test

  def fetch
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    system "zig", "build", "--fetch=all"
  end

  def install
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    system "zig", "build", *std_zig_args(release_mode: :fast), "-Dversion=#{version}"
  end

  service do
    run [opt_bin/"chock", "daemon"]
    keep_alive true
    log_path var/"log/chock.log"
    error_log_path var/"log/chock.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chock --version")
    ENV["XDG_STATE_HOME"] = testpath/"state"
    (testpath/"project").mkpath
    daemon_socket = testpath/"daemon.sock"
    daemon_pid = spawn bin/"chock", "daemon", "--socket", daemon_socket.to_s,
                       out: (testpath/"daemon.log").to_s, err: (testpath/"daemon.log").to_s
    begin
      100.times do
        break if File.socket?(daemon_socket)

        sleep 0.1
      end
      assert File.socket?(daemon_socket), (testpath/"daemon.log").read
      port = free_port
      pid = spawn bin/"chock", "serve", "--daemon", "unix:#{daemon_socket}",
                  "--project", (testpath/"project").to_s, "--host", "127.0.0.1", "--port", port.to_s,
                  out: (testpath/"serve.log").to_s, err: (testpath/"serve.log").to_s
      output = shell_output(
        "curl --compressed --fail --silent --retry 10 --retry-connrefused --retry-delay 1 --max-time 1 " \
        "http://127.0.0.1:#{port}/",
      )
      assert_match "<html", output
    ensure
      [pid, daemon_pid].compact.each do |owned_pid|
        Process.kill("TERM", owned_pid)
        Process.wait(owned_pid)
      end
    end
  end
end
