class Gitv < Formula
  desc "Terminal-based viewer for GitHub issues"
  homepage "https://github.com/JayanAXHF/gitv"
  url "https://github.com/JayanAXHF/gitv/archive/refs/tags/gitv-tui-v0.4.0.tar.gz"
  sha256 "d9374f0ebaab223d16099ad47a55b9f1510c23bf4c89203f35fa12c21116748c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/gitv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138c64e3973c519b3c7ccd8b173f0f76aebb4b2a9e3e732cc60f5a09812163b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "984d4a4dc41c963e644393850f6a49908f7622ed06bdcd9c2097a2d236fe0c59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67c6c7cef3a6daae2413db523ab604e1752c78c720b175fe6f451cd883eae2ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f54b61f4f616c44d8fb98ba18f7a6bcdb1a91168dac2ca331b1d561718c4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb4aa49570f361ee0b0b0cb7c497b95212896829c8be71941007edeeac46abe"
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
