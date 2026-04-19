class Gitv < Formula
  desc "Terminal-based viewer for GitHub issues"
  homepage "https://github.com/JayanAXHF/gitv"
  url "https://github.com/JayanAXHF/gitv/archive/refs/tags/gitv-tui-v0.4.3.tar.gz"
  sha256 "36f3eea4b2cc9cfe37278df0357172099e334092320253ddba275e22c771d971"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/gitv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "366a843d20a55f7759915c83922c4e17dfc63ccd627519385f12fc525e5cb9a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da4cb2f3c62b237470dc342accaed866550949bf9ce6e6ff08af15957dae1967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03d908f376bd131eff02825c6afa5bd1748fabf074ac6ac9a977088ed04b468a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43368dddc94570588550949a5d0643db1e2f8c87bea480e930b48b13d4a24825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "111328b3c0c5285b4d31475e02d2f35743775812a601a9b0c13825a4c8021a8a"
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
