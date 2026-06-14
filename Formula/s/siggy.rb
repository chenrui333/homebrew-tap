class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "197b706c927eaa4bd561e239a4ab9c7a679e9a644c2f5137d2555df1287e6634"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57a2db7572579076ba730edc3386c3b68f91615b8f038a17e7a81d68d2324305"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71889ecb212a5406d730102cf169288fedafe763a62308af41c019ed3ee6e9fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472285850fcd940ba2b0072b12a7314023949ebf5a50b52035fa27f3098419dc"
    sha256 cellar: :any,                 arm64_linux:   "ee8c5194c779bf70c621a317eebb2fd27b83b315f9fdcb3bc87e8916600b5d74"
    sha256 cellar: :any,                 x86_64_linux:  "7d91eca655b9d9196c69c509ebeca9968eac12aef162690bb118c13260a09ca6"
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
