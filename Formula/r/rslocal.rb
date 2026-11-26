class Rslocal < Formula
  desc "Tunnel to localhost built in Rust"
  homepage "https://github.com/bonaysoft/rslocal"
  url "https://static.crates.io/crates/rslocal/rslocal-0.1.0.crate"
  sha256 "77b0b968939cbb94dbfbcfc227e65836883651de12221c6ed8d119e970f6a1b4"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "2c950fb5519f522924a8ffd1a9dbcf083eab28576c883ea2a21fd082e913c389"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f1fb2b7be7995c8f3934a368f00e23772d0ed0a0374e602cc78512d1ad9ce60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e63099841076cc14a481690fb90ae16cd1bb7b8efbe54bea6de9babe12f96b59"
    sha256 cellar: :any,                 arm64_linux:   "f4e5bc47dd96a0bea2d5dcb014543d0e6f75e80c3269ed85711f8519bb602b6d"
    sha256 cellar: :any,                 x86_64_linux:  "6ddee6466d557567ba18e03630165017e9e91533b3b55676773ee94cb6a27105"
  end

  depends_on "protobuf" => :build # for prost-build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Without a config file the client fails before contacting any tunnel server.
    output = shell_output("#{bin}/rslocal http 8000 2>&1", 1)
    assert_match %r{configuration file ".*/rslocal/config\.ini" not found}, output

    assert_match version.to_s, shell_output("#{bin}/rslocal --version")
    assert_match version.to_s, shell_output("#{bin}/rslocald --version")
  end
end
