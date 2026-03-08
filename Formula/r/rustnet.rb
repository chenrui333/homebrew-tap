class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "65030c42811889360cee9edb0e70da2f5d8dd90fb80554019e300629741b6875"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ddd978a827f77ede3ff7f8b91567ae1fb9f13b7dc841f80146318774f7a2901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b44858e7808871d7c089a78e37bc09898a6afcb5f8dd7971278e2e4ffdb3a19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "169ea1759ff6d1cbbc6a8ef2efbd1d97e4ba026c6d818fe523a0953d4fed7b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8c0d32d12de872c6a190592a256c06ecbcf77434f0a843a7152af2b5f8ee01b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dd5cdb2de9cbd519e2dcfca611d87630d56eeb4b3ae2ba91b88e24f1e242c05"
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
