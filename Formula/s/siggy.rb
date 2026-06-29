class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "2214519d9268fa747030b7423dd699d87eb6e031e432fbc32958ce42f828e3b9"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41813146bdc24ab6fdc3ac10d351d1f0754322b8bc89eeec71e050e6d2dd408b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "390de106471adaaff68191e3464823ee2b8ddcfe5734444d278861105ab91ab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19e386c51b47160ec1375e68ee5f464d01eb0afd3020986df95d860c810ecf87"
    sha256 cellar: :any,                 arm64_linux:   "f511cc3db3115fd228a152020794d91b78c9a4264661e0173433fd4f5e8d7701"
    sha256 cellar: :any,                 x86_64_linux:  "470935a42e2bf6a7e56d94efe17780635cafe5858ede07b42735a28cfaaec9ea"
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
