class Siggy < Formula
  desc "Terminal-based Signal messenger client with vim keybindings"
  homepage "https://github.com/johnsideserf/siggy"
  url "https://github.com/johnsideserf/siggy/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "84105115bbada8fd4002077330953586fcae77afb4437d5ab121526a88daccdd"
  license "GPL-3.0-only"
  head "https://github.com/johnsideserf/siggy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a11120d6bc7dcbc07e7b6e0c736bbe0e8f4cc6314b9826dab0a0006cf867685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e52a4c40a5f95575957191bdf5012caa30fbeb32a279538c24c4eca09a51987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5c85c1fabe9b189bdbaa6d5709918ff3097a80b611488e336d5eff17432a32d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a3bec65a7e8892428067792d813c92c23699d6cb6a14b1eba03a50b82a72ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7f457d82d23d455d72ce8dccd19b32c49475e3698006f2de2b43a4b34edf28"
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
