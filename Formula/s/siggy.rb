class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "65f8ad94f569d478fca079984a792799e644c86a228576f0febf889220e14b55"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "b18e9d25e30e90fc5e9faad19e1930e00699480f6d6bacc94d9a42639da55ba3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "615ef1cbec9546b1151520207d8fe8ee8ec445ad401bd6b4234d583d6f901d8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f19be4a7148dca9477ac90175a0fa4230e35a80efe6dffc59da734fe4ef7eec"
    sha256 cellar: :any,                 arm64_linux:   "45a592a8981ae5635ce1aaa39cdd1f494f897dff0752776fc3af945f61a183f6"
    sha256 cellar: :any,                 x86_64_linux:  "3bea23349bd2677269920e89f35f9a433470abc804a6f83549e9e2b76a31f412"
  end

  depends_on "rust" => :build
  depends_on "signal-cli"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "libxkbcommon"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    log = testpath/"siggy-demo.log"
    in_r, in_w = IO.pipe
    script_args = if OS.mac?
      ["script", "-q", log, bin/"siggy", "--demo"]
    else
      ["script", "-q", "-c", "#{bin}/siggy --demo", log]
    end

    pid = spawn({ "TERM" => "xterm-256color" }, *script_args, in: in_r, out: File::NULL, err: File::NULL)
    in_r.close
    sleep 2
    in_w.write("\u0003")
    in_w.close
    Process.wait(pid)

    assert_match "siggy (4)", log.read
  end
end
