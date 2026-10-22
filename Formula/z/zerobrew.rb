class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "c5c604cca5bc0feeb5eccb1b12a69af843401fe9f92fb8130921f4af2d304ad7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f5709627e9737bbe2bb7b1a476e444c128bef3d56a9fd58058d24487bbd478a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "134348a8ed7ab5676e28314c225b240bff613483e80a9dc1d36d73b1c795be79"
    sha256 cellar: :any,                 arm64_linux:   "a98023ca8f7aac603a82e9d8b495c00dc82a5dc74d79cc58a2338307605e97f6"
    sha256 cellar: :any,                 x86_64_linux:  "de611e6d36ea4138b8fde7597278a026ddfc1f4add2180bd50d0446e29151159"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
