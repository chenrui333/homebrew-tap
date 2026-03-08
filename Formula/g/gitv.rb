class Gitv < Formula
  desc "Terminal-based viewer for GitHub issues"
  homepage "https://github.com/JayanAXHF/gitv"
  url "https://github.com/JayanAXHF/gitv/archive/refs/tags/gitv-tui-v0.3.3.tar.gz"
  sha256 "0ba26f072d877b3a2c9add8a84c7d70f61255bb8c64933faba8996ed5c0e00f3"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/gitv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d7f9b103974c832019729bfb7fa2a7c68ab80c37f9943acc6e2c5079812ea34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a743cd7f2c49806432b706590a10f84a5555c8fe84c2d959a99b84b29eb28cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63597e3ae14695729bb7fb8caf9cfed93b672a655889daf26143ea7951c8edc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b64c1eb50f4e4c7dcb9edd6cb9ae75fe08dc073eabb47cf54376966b54a302f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "527ad6c99bf781c7b21e5e1bbc4b4c23f79c627cc26800d10b8b7b2189101e4d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    ENV["PREFIX"] = prefix
    system bin/"gitv", "--generate-man"

    generated_manpage = man1/"gitv_tui.1"
    generated_manpage.rename(man1/"gitv.1") if generated_manpage.exist?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitv --version")
    assert_match "Log directory:", shell_output("#{bin}/gitv --print-log-dir")

    ENV["PREFIX"] = testpath.to_s
    output = shell_output("#{bin}/gitv --generate-man")
    assert_match "Installed manpages:", output
    assert_path_exists testpath/"share/man/man1/gitv_tui.1"
  end
end
