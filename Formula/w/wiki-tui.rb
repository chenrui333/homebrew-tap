class WikiTui < Formula
  desc "TUI for Wikipedia"
  homepage "https://github.com/Builditluc/wiki-tui"
  url "https://github.com/Builditluc/wiki-tui/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4f51547c0597ee9d6be9e946a612bfc052f8addd59b01f2bd599b31c3b636004"
  license "MIT"
  head "https://github.com/Builditluc/wiki-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75db1acdff9d7b7dd1210177215fafcc9d16348c59dc00ced6a8ba30d230f7c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e56f0605dc6bd9da7557d29c9aa63a5e6c1300df53251cdfc031b501ddbe396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4e0896de4cf127d7e0ec4aa0d80c139c3e97e0d6227eefa4cc6eca18f47c8e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a9df923fffbb3253701a3a5315a1868698228fde826d5db2d2ce14a6927636e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "717ef01f36c62909fabbc3cda15c07a319a43b0c500da83b1d3500ae048879bc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
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
