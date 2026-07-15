class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "154c02db19f5cadb91d9556bbd9f62ec48d5525dff76f4165a7d2d5fd6454ff6"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0ab7736352587aa940a3d5925abec8792487ec97e8dc3852022eb0a2de08e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "747f929009458ee3225d507fdbf62565d3d565fb099475599e992ead23475787"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d6c74ee7b887ddbe3f59b554b9b3ef5b881598aa2078b85af17af229d2bd4b"
    sha256 cellar: :any,                 arm64_linux:   "685d230d4a28c1f44d91f316dab22ff10f91e255f2e6b02b6aba7b1742f85635"
    sha256 cellar: :any,                 x86_64_linux:  "af1bdce9d343da7ddca3c010a49828d25a8e6548f873ab8b889b013aaeca4f55"
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
