class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "197b706c927eaa4bd561e239a4ab9c7a679e9a644c2f5137d2555df1287e6634"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "094299d01325ebdd92b21f283824d8e0fb69b78456ba5f6500bd48886c290268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7040708a30f9922b81cd30d89a30c969f2d4a25b8a17628df38367ae2d3c9d57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "699a5c4a77f0002a9fb63213781a2d0669b0880aad72af0b2421f09af56a081d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1aa00c949a7df342fbafd8e66c92d1d7c63cc9d70aa114f06b049b7cce7e6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da0db6780cd881d0bbbd66c8841780ec7d8c39f8c5c2b0d3d3866282ddc40290"
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
