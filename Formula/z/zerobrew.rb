class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "cd91c6acb2d0b5dbffd9cb3e9b6512056bf6218a826bedaffd2dad3e2c9e9b31"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "317518386303dd2bfaefa6bc2e65b15d86601f2be14423ab28009f42f4801292"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df56614413a7a4a6debb7a7bb951742d5186110aa92e8fc84a5252becb4fdf86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1529db0ee29edda2f2f4ebc13221ddd7c86b0a95d54bf5dff4f43afea6e98d4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140f95d85d343ab5a92ca2959d491715477b19fd6d452b2db3422bd1476c5414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "938ebc9e4a3a58cd352c14b86eaabf7e10f4e43164a24e106c1acff7eed722c3"
  end

  depends_on "rust" => :build

  def install
    inreplace "zb_cli/Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
