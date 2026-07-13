class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "b3769b43b0bbfb9e6b1958511ebb0a49bec12fa3762c60357adab0a19f1cd86f"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "078e462796819eb89607575625230b75c74a4ed66b40ad19833dff576a83a64a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81d91938ba5a2b9570d1afb59f7b6595b2d669c0cc0733a1f9ee7ba249f174e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b260b8f5c5f7cdcd906955edc2ab8b3b8b6cecda9412b30821c32ea62ffe19"
    sha256 cellar: :any,                 arm64_linux:   "fa1376f3dc4d721a5011f3bc0c73382a80cda2c08eab73495b32b5fec7becb3e"
    sha256 cellar: :any,                 x86_64_linux:  "52a43621cb6046a55461a9cf41a729d24afe83fdc03646bba3f315a54ece63ab"
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
