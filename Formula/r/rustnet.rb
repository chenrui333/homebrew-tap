class Rustnet < Formula
  desc "Cross-platform network monitoring TUI"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a91773ea19848bcd75339d21b1a811944ef2490feaf8602d5cee6064f4d96ff2"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "239592ee9c0c9555938ca75f002be7c658672c740ff7757f6754f1a9157cd114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c2375c161419db4451573e37bc3a1c28b3cc99166346c3a769ac9952c2235cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0dd4daa4fd363036074330f2e00754ed3f85dd8007bae0af4934bd99f554c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d5f0d3985bbf83a38f3576a8c5db0a667a8b2140e87d6261e4075d9cfe1b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3c23e2a5101bd1076947a17aa2fb0f504e9a24682e2a2a2b7ee93f7d8dd7cb"
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
