class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "5896074797a34b9b62580077f8a0cf0bb78cafb6e0c2c3977ecf2f063a41bda2"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "269666419395903d802e20f298f5589d9223166798f0eea9bcb1fba177c1770a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ce2666172e4569c24b912e6a645760c1a7fcafcf1ff56b67eb07f16a3567d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e3dab2b820af690f4cd807d0bc0b08d9e160d7361e40cefdfe9782e3e9a1f2"
    sha256 cellar: :any,                 arm64_linux:   "b994f645bbebb7adb93eadd82f11b2ee2da14b253f0bf89af893c597e0f638f1"
    sha256 cellar: :any,                 x86_64_linux:  "3e84e5dc3109c36b4c450ec0027cee8303adda6ea4643e4a1588f87d43124225"
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
