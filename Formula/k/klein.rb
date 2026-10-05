class Klein < Formula
  desc "Terminal-based text editor with IDE-like features"
  homepage "https://github.com/Adarsh-codesOP/Klein"
  url "https://github.com/Adarsh-codesOP/Klein/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f3e294063386d5a0eacba0706cdee56b5a476caed2e7d11a7badb5eeb4df5e15"
  license "Apache-2.0"
  head "https://github.com/Adarsh-codesOP/Klein.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36c3746af40b52ef4bdcaa837bcf945b5b6ca0abf0c8c739403eb169c7570a80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "253f1db4dff0232b32c21e115891a8b76cac923d1ae274ff521f87464238bda9"
    sha256 cellar: :any,                 arm64_linux:   "074948fb93c018a69d3d36aa5efdcb2043934e32234c55fe7947bfdbbe22a775"
    sha256 cellar: :any,                 x86_64_linux:  "4b5f9c0363a2cbaf8fd616606c3bd34c2a20a7f54309d54ba0324032218a401a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libxcb"
    depends_on "libxkbcommon"
  end

  deny_network_access!

  def fetch
    # Fix the stale klein-ide version in the v0.6.0 lockfile (Cargo.toml is 0.6.1).
    # TODO: Remove in the next release; fixed upstream on main.
    inreplace "Cargo.lock", "name = \"klein-ide\"\nversion = \"0.5.0\"", "name = \"klein-ide\"\nversion = \"0.6.1\""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "terminal-based text editor built in Rust", shell_output("#{bin}/klein --help")

    (testpath/"test.txt").write("hello from klein\n")

    out_r, out_w = IO.pipe
    script_args = if OS.mac?
      ["script", "-q", "/dev/null", bin/"klein", testpath/"test.txt"]
    else
      ["script", "-q", "-c", "#{bin}/klein #{testpath}/test.txt", "/dev/null"]
    end

    pid = spawn({ "TERM" => "xterm-256color" }, *script_args, out: out_w, err: out_w)
    out_w.close
    sleep 2
    Process.kill("INT", pid)
    Process.wait(pid)

    transcript = out_r.read
    assert_match "?1049h", transcript
    assert_operator transcript.bytesize, :>, 1000
  end
end
