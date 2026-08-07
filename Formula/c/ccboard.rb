class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "bd16b845a5695e29ddbd4f6ba02f6e4bb407844e91b2d3f3ef7c1bea1d838f10"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9292ebe1226c247a08ab798c9d2b82457f11144f294e8a63da0ede49ad21256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b35061671cadd88fd5a3bc2a34532dd14c465cda95d76de9d49c62c38a44f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "411368b3eb70e83cd163f2bc9712ed9487ea29784c811fccbc1ef74051c328c6"
    sha256 cellar: :any,                 arm64_linux:   "fc97cfb19dd40f177f0619e8098646531101c198db02b14c9880f34360821f26"
    sha256 cellar: :any,                 x86_64_linux:  "5539a86e7f65ff82bf4c88e5debcda4167aac524311a379db6696aaa9c8dc1c5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ccboard")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccboard --version")

    claude_home = testpath/".claude"
    claude_home.mkpath
    ENV["CCBOARD_CLAUDE_HOME"] = claude_home

    output = shell_output("#{bin}/ccboard stats")
    assert_match "Sessions indexed:", output
  end
end
