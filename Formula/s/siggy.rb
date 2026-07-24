class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "88254433e59240c0bb7baa0c8392e23b4be76cfea5c1c17dd80966888b553434"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07275b5fc36eaa1960307b5a24d9cb6980a93b3cd0f984bcd838b773e4cfe337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "337dbef493870601c688ce1cdbc24e1e1fbb0e86f019e6e3e4dadf7c23172fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c2231f6f81a6205edba74c9d4212226a30a952a989f16d2e2dc171c36bf5af7"
    sha256 cellar: :any,                 arm64_linux:   "8908d986ec1f1e09c7f8fa097e7d4f30e1dec1beea8b50c9a0b7f58572c4c63c"
    sha256 cellar: :any,                 x86_64_linux:  "bd1776674651e661ca0ead0024a925e9d1bd0c940d181c8f5176a422f6538870"
  end

  depends_on "rust" => :build
  depends_on "signal-cli"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "libxkbcommon"
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
