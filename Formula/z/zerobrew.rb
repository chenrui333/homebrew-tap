class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "59dc01b4eb9f1bee71f4ed9c2a7210fc45c49570e5696534ef246d99879162c1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f82e3cc3d735d1886ec9a54d8dfd3d83b2c77c46fcec09ffe1dba41e228950e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1844774d5cbb79cec3fc4b8d24e6dec4ea5fe663f1809e793dee27a00fee6d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf712f58ed4d0e8967fed8055975ee73b86d3248d7cd68cea85ad926a40a584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79097fe804481ac72f50725558cc36d528c038d24a98fb67d813050270e2fb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "438b196bdcf972ddaa5480634b9efee997de60bc0ee2b5b47898653b47b34afd"
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
