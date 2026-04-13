class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "d5934a381c3c8fdea69e51296ef1ecf428e30466edf781e3824753a029e27cea"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85d722f80aeb8df3b406c1c92c020292c081adbc9bc5bed651e0ae1099f5a25b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3211b5d3b54ca6f1e8384dc8546d6e3dbc025e7024d1c3cd2a2337e6c2c5e21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67aee9f9cb477d8751176ec3ac151b1d2aca214d04a2ba6e5fef0c4d43b03c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d24b8fbc2674daf1bf9ecedc992f845cc2405e2dcdc27261112d195dc92432d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6955d59398dd6197b82c793475c9bb71a608ba3d90a8cd8eb291d234216941a"
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
    assert_match version.to_s, shell_output("#{bin}/rustormy --version")
    assert_match "Cache cleared successfully.", shell_output("#{bin}/rustormy --clear-cache")
  end
end
