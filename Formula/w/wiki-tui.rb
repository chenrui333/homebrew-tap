class WikiTui < Formula
  desc "TUI for Wikipedia"
  homepage "https://github.com/Builditluc/wiki-tui"
  url "https://github.com/Builditluc/wiki-tui/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4f51547c0597ee9d6be9e946a612bfc052f8addd59b01f2bd599b31c3b636004"
  license "MIT"
  head "https://github.com/Builditluc/wiki-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5641b6422e93fb7126a562e23a55b16fa703e6b2f0d2f1de52d44f4a9145d93b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7afa531968e6720d9265f71c5820891811b1bcc5a1ec996481d9d33392f020ba"
    sha256 cellar: :any,                 arm64_linux:   "a43476f6b2e7b0c0f3c3eddb8e3f6ac43a935f0756af687cbcce62b468007ae4"
    sha256 cellar: :any,                 x86_64_linux:  "7b29da06a9c45b1496cbd2832b4760aeeba7666591afa0961dc2f2112d243309"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiki-tui --version")

    output_log = testpath/"wiki-tui.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL, bin/"wiki-tui", [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", bin/"wiki-tui", File::NULL, [:out, :err] => output_log.to_s
    end
    sleep 2
    Process.kill("TERM", pid)
    Process.wait(pid)
    output = output_log.read
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    output = output_log.exist? ? output_log.read : ""
    refute_match "No such device or address", output
  end
end
