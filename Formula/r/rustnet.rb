class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "245fc7074d5f142fbf1c798233be86b715b4f2ce3b3cfec10fabdcbbc9345ddb"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "222ca4b57aa92d32e71dc417f4c58eacb5acbc2eea7e180c4e99b6cc86998504"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8add3ccf2ffb91f22831efd6a125b9de2b21f56e75ce69efe09d7d42b046a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620210d05f179f42f016a03e002425cb59f4b1a0fab16d742afd8c43daf2e9bf"
    sha256 cellar: :any,                 arm64_linux:   "811b5e07452c0cc974dabc95b96b546640f9f63ba30e35136d541a28b392d1f3"
    sha256 cellar: :any,                 x86_64_linux:  "453ab99c080a2480fc3af50c75a8cf105266dbc3d935116f7e33421b17d2a1f0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libpcap"
  end

  def install
    asset_dir = buildpath/"build-assets"
    asset_dir.mkpath
    ENV["RUSTNET_ASSET_DIR"] = asset_dir

    args = std_cargo_args
    args << "--no-default-features" if OS.linux?

    system "cargo", "install", *args

    man1.install asset_dir/"rustnet.1"
    bash_completion.install asset_dir/"rustnet.bash"
    fish_completion.install asset_dir/"rustnet.fish"
    zsh_completion.install asset_dir/"_rustnet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustnet --version")
    output = shell_output("#{bin}/rustnet --refresh-interval nope 2>&1", 2)
    assert_match "invalid value", output
  end
end
