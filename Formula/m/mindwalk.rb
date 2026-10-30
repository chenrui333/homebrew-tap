class Mindwalk < Formula
  desc "Replay coding-agent sessions on a 3D map of your codebase"
  homepage "https://github.com/cosmtrek/mindwalk"
  url "https://github.com/cosmtrek/mindwalk/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "84d2fa1506a7e0e0f794e81e4fcd80505a48846cc2472e9ede82942581d92a82"
  license "MIT"
  head "https://github.com/cosmtrek/mindwalk.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5fa65c65ebe46be578ff151df077b014c21bc75c6bd2d2d4f513dfd3750ef8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5fa65c65ebe46be578ff151df077b014c21bc75c6bd2d2d4f513dfd3750ef8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "120d381b27432b9a6096e8687b41628ff4e836e83100d62efaa726921fd72699"
    sha256 cellar: :any,                 x86_64_linux:  "0e5c4e371a0e20cbee90c78ef4cb467800dcdacb81c7983071e2c4593c239c40"
  end

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
