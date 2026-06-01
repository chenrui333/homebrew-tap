class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "fe589916752d967be3fa38da38c72941132f2ad9525037a1244563b1b035ec8d"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fa2327be30b57ad2af74c5674f5cbdcfdb6329f43364edec090973298fb673a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1199d3dd615bebc08b50b834103992d0d8c3fb78f3675470ab5dba138bd3a3f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7599ed75571b32f7c256db613f8b7e69e61b9463a2a606ab5d23ebafd8df5d61"
    sha256 cellar: :any,                 arm64_linux:   "88220c194795e250592a948427d7000b02a247416a10124d8aa774b9754d8649"
    sha256 cellar: :any,                 x86_64_linux:  "698ba128277449c2138ad5c43527eeb74544c4dbf2f882eac8411c758851b7c5"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitpane", shell_output("#{bin}/gitpane --help 2>&1")
  end
end
