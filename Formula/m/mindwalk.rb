class Mindwalk < Formula
  desc "Replay coding-agent sessions on a 3D map of your codebase"
  homepage "https://github.com/cosmtrek/mindwalk"
  url "https://github.com/cosmtrek/mindwalk/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "84d2fa1506a7e0e0f794e81e4fcd80505a48846cc2472e9ede82942581d92a82"
  license "MIT"
  head "https://github.com/cosmtrek/mindwalk.git", branch: "master"

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "npm", "--prefix", "web", "ci"
  end

  def install
    system "make", "embed-static"
    system "go", "build", *std_go_args, "./cmd/mindwalk"
  end

  service do
    run [opt_bin/"mindwalk", "serve", "--no-open", "--port", "8765"]
    log_path var/"log/mindwalk.log"
    error_log_path var/"log/mindwalk.log"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    (testpath/"sample.py").write "print('hello')\n"
    map = JSON.parse(shell_output("#{bin}/mindwalk build #{testpath}"))
    file = map.fetch("files").find { |entry| entry.fetch("path") == "sample.py" }
    assert_equal 1, file.fetch("lines")
    assert_equal "python", file.fetch("lang")
  end
end
