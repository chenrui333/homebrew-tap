class Shuk < Formula
  desc "Filesharing command-line application that uses Amazon S3"
  homepage "https://github.com/darko-mesaros/shuk"
  url "https://github.com/darko-mesaros/shuk/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "da15a5c54e55c127a54f69daa36aa904ba22ca59e805d53ae5b03a172103f096"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/darko-mesaros/shuk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "737552e6826e5618293b66052e5d44d3da049b9478d09742c132d054d09c440d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b50147dd2953d0fc1c45fe2492452cd39312a6842571e62dba5481df7a12234b"
    sha256 cellar: :any,                 arm64_linux:   "8bfdc58da583c4f85ec48fefc0de62459219985b9ec3146fb9fd4bda87a54ddc"
    sha256 cellar: :any,                 x86_64_linux:  "4259035b95bbeb9529119b2baba852b05158fbe0b5fd406a0b6448ddfc89f067"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuk --version")

    output = shell_output("#{bin}/shuk test_file 2>&1", 1)
    assert_match "Could not read config file", output
  end
end
