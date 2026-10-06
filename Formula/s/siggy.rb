class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "5896074797a34b9b62580077f8a0cf0bb78cafb6e0c2c3977ecf2f063a41bda2"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98570bb4914df2b7c7f93c8b8cee1f85ec393a7abb4bc2bfb085950c660bc281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f370a31d021d4bf7c883b46faaa5dea76b4b8f7fd865cb1ea7cb944f6d44b330"
    sha256 cellar: :any,                 arm64_linux:   "27283124afb7d674cd071b85f50e3a77204d5fe7859795cc6ad2e6211d55c7e9"
    sha256 cellar: :any,                 x86_64_linux:  "09b9421fab9f7d8ef98d7be449a949b0bf20cca9f50869957f389f575a844262"
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
