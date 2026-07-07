class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "0861457616d2a7da7dd0b94f96c6f7f79e9a69b1dea15401e761dacaa68f6281"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db996ced0520583dbbe98bd7e7d440efce87ccff9781e390ea5d1408ea8e3a29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a43e6e9d0f2b3f0215bee3cb77bc4cc7ef414b49b69b4884690a410e3148dff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f11eba31e1e9cc46a0dfb59750173c6e7178fd3f9353b25128f7485166ac1d"
    sha256 cellar: :any,                 arm64_linux:   "98b1ef16cf8224831433df3819e8f888dce1b97d949779fedfca412bd612f854"
    sha256 cellar: :any,                 x86_64_linux:  "a96bb44282c6374ed45b77b86d7ab5e5c970708558f10564a244a0f6270bf71a"
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
