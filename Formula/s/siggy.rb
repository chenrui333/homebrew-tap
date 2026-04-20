class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "aabedbb5d6f9c58551e66ab572b20093d3d3c0e09f161f12c128ca372495be84"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6beb98914c1406c81e8756d7e5e5354843861cbfbd9b5113e5a1b03eef4354f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c335563f1af319c3fbf30df88d76d59d60b0ea896eed06c2bac09b99d57e418a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c407b88815d738a47222bef27fe3d38a58837fd97e4f76525b333a15d55406c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a609ff729fc661bc35cbd5f2d08f85da5c56378d7c65609e072a17f55b6ed96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49774b7e1a13bee7fda999e2fc98a25ded3675cda69e0c12a9344cfd9fddfd8b"
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
    output = shell_output("#{bin}/siggy --help 2>&1")
    assert_match "siggy - Terminal Signal client", output
    assert_match "--demo", output

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
