class Gitv < Formula
  desc "Terminal-based viewer for GitHub issues"
  homepage "https://github.com/JayanAXHF/gitv"
  url "https://github.com/JayanAXHF/gitv/archive/refs/tags/gitv-tui-v0.4.0.tar.gz"
  sha256 "d9374f0ebaab223d16099ad47a55b9f1510c23bf4c89203f35fa12c21116748c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/gitv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5158ea55c8e1564463a1906249441ab8871c338ff97c1b463bd66c97a8643dcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe12470c468e32b0375880e3e9ecc9f6dda271be709fb9258f4098b99e52e224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77ee324e2de466b908348e648efb06d29f51dd28ea8bccb1ee16aceeac4b1229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db30d5c8473e7197b4ee66dcbb958c5a1bcbabe96c2114e161eb11f5473e4a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4475d9141f1d685f628360d2aeb7b3819c503b264c624de7914b01e0de0a09"
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
