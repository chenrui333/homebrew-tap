class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "5896074797a34b9b62580077f8a0cf0bb78cafb6e0c2c3977ecf2f063a41bda2"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13b9ffea9ea6fd362840e17c42828df97b6d508bc7e9714f014d7bf9e4859c71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6846724185e1d54b93c9f26ad8ca61e86318739df09213470bda01d2308fc42a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e28db2418efd6f177717294b4d99ea01b0f0262f2fa05cddb48f5018580af380"
    sha256 cellar: :any,                 arm64_linux:   "08438e7ee3aebd990bff47b7c77bc4b5c4fc1d53fa32b6393ab9aeda975733c6"
    sha256 cellar: :any,                 x86_64_linux:  "3a47fdcb6d8e93bb84703633bfd3b79619d2f4553871b5480e71bbaf5ea4da3d"
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
