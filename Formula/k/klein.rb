class Klein < Formula
  desc "Terminal-based text editor with IDE-like features"
  homepage "https://github.com/Adarsh-codesOP/Klein"
  url "https://github.com/Adarsh-codesOP/Klein/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f3e294063386d5a0eacba0706cdee56b5a476caed2e7d11a7badb5eeb4df5e15"
  license "Apache-2.0"
  head "https://github.com/Adarsh-codesOP/Klein.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "321a6a08b64c0ce6a768294d3d1e1c2a5e444e8afe96057602fda01a6534f4b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ebfd29ded67ece7b57e6be9a32ff41d2abc95f9cc2ab5f12a1db41fe1b1069f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c6944b7912b7f6075ef25a5f884d790b2c054b9b3ce8ace81bf059ab3d2b185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa8bb6069374ff5f4bdb7c07ffdcb7315e6593b88c69364be12b6db5b99110b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a5c9efe6ee5e485c8c13ebc20a51d113fbbda4890a9faa6fa84e31e4e0d2cf1"
  end

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
