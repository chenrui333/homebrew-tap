class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f6425992dc5a8a700323c1231d1833a135cd93424d86cfaa788eed6cb700fe33"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "921239f121c5a421dad4a4a6bf99c530292dfb974eca3d4e1006e1b3850699a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "513be57d1e3fd4efceb2176b53b1f2756e7fe121d858a3ba8a5eef767bb4c223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eb12abb9d842edc453dc175b74f0705aa85cdd62134e5cae501b4f3dc8a47f0"
    sha256 cellar: :any,                 arm64_linux:   "537eacac87b945cc93e32d11d3a6f039c2b720571690b34c004c96cc454e4fce"
    sha256 cellar: :any,                 x86_64_linux:  "cae8805ad1cf1ae8ab029d613652cea757797c30a5ea4fd4dce23ab8dbfb399f"
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
