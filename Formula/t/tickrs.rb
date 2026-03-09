# framework: tui-rs
class Tickrs < Formula
  desc "Realtime ticker data in your terminal"
  homepage "https://github.com/tarkah/tickrs"
  url "https://github.com/tarkah/tickrs/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d06648feb9d0da53f10188f050e8324162a1a83a1ed0f2f7a360983dc2f2b0a6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b4700c2115a1bc326702cd1a29b3da0cb6cbca240d40f5f4bcdc4d2d115f6fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "427bdf1ad0b6943e59e81cf570997e2730ec533a14810bc831ed035a6f76cf1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4047694bbd804badcfe4cae9f3f1fb611769836f58669f72ddc7a079ae3f3a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d08bbc9e16bf1866bd3144acf366c53ff1b901a86cd42c2147314290d4e362f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c4a5c5f3cb824eb9f9ff70b57a04b83cad48813b275b0887ccd98f465e6952"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tickrs --version")
    assert_match "Realtime ticker data in your terminal", shell_output("#{bin}/tickrs --help")
  end
end
