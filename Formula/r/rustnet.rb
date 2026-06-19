class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "846f89a9c6cb5a2de6b9d42cf5a8a435e343906cbe9083776ddcc7fdbbb8857b"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "208d5c90c16b1a3ca2e766a3001aedceb7526cd189f4c11bad507ea60f17c43e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94686a9409acad044d27d74f5114478de7702b77375ff565349c49064b0895b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "debf7176b6c84cf854b8ac727901d5abfa02daf6992706d9d47dd7620986f784"
    sha256 cellar: :any,                 arm64_linux:   "e48672bc275e4eefe6d54d0a977945b4e0accfe1370eea6e9b849997dd0d4d98"
    sha256 cellar: :any,                 x86_64_linux:  "55accc4e4763ccd151a9bcfdc5015f135348b5973a2c2f1299e6c31aaf5d14df"
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
