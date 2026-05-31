class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "e35b4f20a04866e67c553e2467f9f57e254b67ada1a2e53c74aa9fbf174f5a3d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15baf6b044764e9c32e5424e5987e560f0e6172b729b8ca7fe4b83839d6f0f44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d8d49b9989cc340fa82bee6d6fdf579bdb1b2510e73a7a3634d1fcb6f6dab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd98ec6441f405fadae8eb9bfa22335d435bb4fcfacfb33f8987b0a05ca5642"
    sha256 cellar: :any,                 arm64_linux:   "b798b1b56979cba9422ed51177ea88a897427fc53c9cd361f96685cb9835f583"
    sha256 cellar: :any,                 x86_64_linux:  "60bdac281f05adb0fb314b7f679b610028c57a111c82f03839c34e4314dfc38f"
  end

  depends_on "rust" => :build

  def install
    inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
