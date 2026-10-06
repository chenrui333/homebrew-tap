class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "9d3f6509da06f832c04c5accc7b777c18f3de8b32c885137c9a1346990694dda"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "742a87f2d1af975f4e45f647bd405d56cff627b69b061581fdaff8a8fe55b934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca1e39366e4138b79116de4cb66b78b1fc0736087d423b80fa4dc6bc93f5112"
    sha256 cellar: :any,                 arm64_linux:   "df4bf0c7de86ce18aaa27e214ebf583ce0feddcc0bf2974c4e93222188f37303"
    sha256 cellar: :any,                 x86_64_linux:  "c452189b50f214eb661c042fb0cd8875eb03ec5c5439d22a82c1286e0c28e102"
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
