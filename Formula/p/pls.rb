class Pls < Formula
  desc "Prettier and powerful ls(1) for the pros"
  homepage "https://pls.cli.rs/"
  url "https://github.com/pls-rs/pls/archive/refs/tags/v7.0.0-beta.1.tar.gz"
  sha256 "3489b5eb0b1d66c6511cf97d47bb098351ea12073ea001e23d0eeeb3b45a3311"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+(?:[._-]beta\.\d+)?)/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b539eb5755156852b111cc152ada9939ae967dba1ffd469e4389b6a684f9cfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "830048fc2e986d657289d9da807e8c87f4ded58d7e639ffb83131719a8f36017"
    sha256 cellar: :any,                 arm64_linux:   "cdd4afc5273792dc7bd38e62fa6316ba75b66d4d08606f8a3acac0873e656025"
    sha256 cellar: :any,                 x86_64_linux:  "4360e64d78e1b7b4006476664b83d029e22eea7783246df0b9af0a91eae7af5f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pls --version")

    (testpath/"testdir").mkpath
    (testpath/"testdir/file1").write("This is file 1")
    (testpath/"testdir/file2").write("This is file 2")

    output = shell_output("#{bin}/pls testdir")
    assert_match "file1", output
    assert_match "file2", output
  end
end
