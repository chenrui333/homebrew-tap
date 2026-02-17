# framework: tui-rs
class Tickrs < Formula
  desc "Realtime ticker data in your terminal"
  homepage "https://github.com/tarkah/tickrs"
  url "https://github.com/tarkah/tickrs/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d06648feb9d0da53f10188f050e8324162a1a83a1ed0f2f7a360983dc2f2b0a6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87e18ea8153bd93f334acd2b35070167c7433651f7826416dd8c6557bb1f3066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9921d5633f6ba016adddd208dd641d62d2baff0f94eb5e9088e2535b150ecb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d756fee147b9b16bb771765b4ea01e3775649173f1ddf4a5f824a2c6e7e3fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e03042da23d840fb4eb95f4f01fe224f088d2dd5e1ddd4e77c39daf4c2c9d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e72911c81b0054ac8c48737f4c4d0e9a22e6e4aff9df880a319ac7b4cb261bc9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tickrs --version")
    assert_match "Realtime ticker data in your terminal", shell_output("#{bin}/tickrs --help")
  end
end
