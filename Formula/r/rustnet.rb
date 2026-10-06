class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "245fc7074d5f142fbf1c798233be86b715b4f2ce3b3cfec10fabdcbbc9345ddb"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57898055afc02acf24cda0ec1a1f60c8588d209c85d07df39dd505eb424e78d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01f7863cf1b6b6c6c384a4c52dea8837f752cd4a72e390b1cae04cdb639fbe60"
    sha256 cellar: :any,                 arm64_linux:   "0d4ed9d6384a0660dbac87b9df36ac01ff98cd7c4925108ea501b7c6c56ad83c"
    sha256 cellar: :any,                 x86_64_linux:  "015b04660a92fa906297790a08bed6fca81f23b26886c7859e6b166d40cb7d1a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libpcap"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
