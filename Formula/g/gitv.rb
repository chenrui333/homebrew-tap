class Gitv < Formula
  desc "Terminal-based viewer for GitHub issues"
  homepage "https://github.com/JayanAXHF/gitv"
  url "https://github.com/JayanAXHF/gitv/archive/refs/tags/gitv-tui-v0.4.5.tar.gz"
  sha256 "b74b28c170060b1681ae26b0c59ee5245eba9967ff4d1e1bdd49d5303f1f07bd"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/gitv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f19f30b92a2e3a07d3ab4558720053681d6617e0cacd75311014e0cf1bbe04f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d8af36e40befd88ac9da14b26113d2f4f1cd51301e210ea18f6453f11d630fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "124d9a6cb66cf346b7ebfdb442ffed92dc1a836992f26a73b99066a9de892402"
    sha256 cellar: :any,                 arm64_linux:   "ecc259512244cedd39e9a3463880bea0a05152dbcc1c2f25ac93486394c8bfc7"
    sha256 cellar: :any,                 x86_64_linux:  "34752f83f10fa66b535f6286e00dfb51ed3c7ca4f7985b015dfbc9611f0b07ef"
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
