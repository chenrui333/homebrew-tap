class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "87eba28668442715af88fe4634f252e5d28c81c90518a50bd97a0f43c1d26482"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faef2e7c109bb9ce1f1accd123946b4ef8bfd83587d3628a8018c8c1c3693231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7804ce0040763d6386d071e8b07d3bcb06cedb00547cc0cbc03973b26de36f8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef116ca7b4ea909a7deff64b7741ec8121c4575a80df4a854fb4f756c1c14ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599b8db02f06fcc09e1915345c5d4d3d7e7caa56acdada178244fb35da6556c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edce3890131d8cd785e046a97a24f1f00247bcf53eb6c46f3ae8fb27a5039881"
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
