class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "aabedbb5d6f9c58551e66ab572b20093d3d3c0e09f161f12c128ca372495be84"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1865a00e4fc854b688b396d90807499c5f53ec61ab6b7229e9d05dc5474c2890"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9f81498a123857fd03b7294d437dd4db41b4c4b98366c7da83fed0e944926f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7241bac475ebf5ca015ed5f1a67e385809c865f30cc1be4c99c47ea32649534"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8551e6ce5c69917d724932c03479f55e6dbcbfb96012aa8e27649096290ff3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d919a2d92a20905211a545e59f79526d6491f179f94436cac00d07671d871b"
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
