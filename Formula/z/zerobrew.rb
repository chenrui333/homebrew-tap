class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "efab8d6171751bdea6ef17b028d9dafccad45ff1252874ab2f1e6f87b4c2bdc1"
  license "Apache-2.0"
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e96beafbf0fa878fd2384ce391dc6df1785785061c94031589b112c8109de9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10194ac452bd6056a4b3d910cfc82facb0dcb4803f69e8004fba2ccadfffa20a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39addda63fabf16545c7bf3e64b00ba16f7f526e205aa224c0a2a85de31a9c84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "357e7069d0cf3152af583661d98d51f4a79086e9bfabb12d791f03140c883225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc19a2b8c1b13f7e984cd15c5d8cff807b7560cfe4d6ef1cc6dc4969aec498f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
