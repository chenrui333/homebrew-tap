class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "258ea142f3ca04e45c33761eb28868a8d8afc62a3f9556a1d5b312e805905ce5"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0101994911382f772a09ae1b5e3842e6269a1992fc162b04ba5efe0fd864ec73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "385e07d78d23f1ebe6d32ff4b34cc342388e48d3dde1242732f6dc65c718e667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "793c31cf2f6c9a56afa4de0cd77fc7a96f2c370a634312e342cf787d155c538a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a833d43465c15b6f33ecf3260cf290698e6418942831c6868601f37263140aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a7129012c282d0ffda1ef1af527c746b4acfca94feb2d12bef8298f36baa4b9"
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
