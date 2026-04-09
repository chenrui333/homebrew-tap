class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b91d41bc715f74453a8cd9ac2cd91e2b3808f01f959e8a92cb65c1f2f717312d"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69429659a9d6b9bd5375ed48b131dea54fe29297fa6de8ffecbda88ba855bf86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ca843298aa573640e3d7169677272943ca8fdeeaa951cc24360405258d28a34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac1ce92d2bf7431ee071693e3aa6a805abd3348a29a8fe65375c4538e87b60a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee68d9de465c50b2753fc61a9dca7ff1b6be295a589d0b9320f19a0cfd44329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafa8a0cb26240b5d76a8cd0256d44d7275708623eb840b3fe6cda8e69f4780f"
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
