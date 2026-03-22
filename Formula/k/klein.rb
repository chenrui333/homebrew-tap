class Klein < Formula
  desc "Terminal-based text editor with IDE-like features"
  homepage "https://github.com/Adarsh-codesOP/Klein"
  url "https://github.com/Adarsh-codesOP/Klein/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f3e294063386d5a0eacba0706cdee56b5a476caed2e7d11a7badb5eeb4df5e15"
  license "Apache-2.0"
  head "https://github.com/Adarsh-codesOP/Klein.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libxcb"
    depends_on "libxkbcommon"
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
