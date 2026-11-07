class ChessTui < Formula
  desc "Play chess from your terminal"
  homepage "https://github.com/thomas-mauran/chess-tui"
  url "https://github.com/thomas-mauran/chess-tui/archive/refs/tags/2.8.1.tar.gz"
  sha256 "890805d2a0426efbc3fd3141a9326e2428057dd3aabb1c822b1861a98805cd57"
  license "MIT"
  head "https://github.com/thomas-mauran/chess-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f289c17bc9af6b325baa6661268acd3eb553c834ae85ca978a79d6d4a17fa0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bc1ab551060a5a9210157404cb2301d27af3817d20f45b906b6ccabda344281"
    sha256 cellar: :any,                 arm64_linux:   "f1c18ee4922a75a455bb4108994716352c1d333c780f49ea522c5432fb29617d"
    sha256 cellar: :any,                 x86_64_linux:  "827defd84e3a093338be2d6486c503c6eaa033c1acf7fd790f121d151f4bd75d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chess-tui --version")

    output = shell_output("#{bin}/chess-tui --update-skins")
    assert_match "Created skins.json with default content", output

    config_root = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end
    assert_path_exists config_root/"chess-tui/skins.json"
  end
end
