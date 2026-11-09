class Mitos < Formula
  desc "Fast and minimal modal text editor"
  homepage "https://github.com/mitos-editor/mitos"
  url "https://github.com/mitos-editor/mitos/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "dfed3c163cb8537989ffa594d6ca4cf5e70d4fe91295f15044c751830de2eb25"
  license "MPL-2.0"
  head "https://github.com/mitos-editor/mitos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "c17f73856e9b301dca2dd1aa36204a990b88fe5ad1f92d8bf03044d88b122efa"
    sha256 cellar: :any, arm64_sequoia: "5d2698ca30e27ba2b729e70ca074bd6c9c9c94b9549090213a5841558bdddfc2"
    sha256 cellar: :any, arm64_linux:   "a56bdee3b5639681e38d6a7b01a95ccc93915c991f500d7fc2c15b6a4f05812c"
    sha256 cellar: :any, x86_64_linux:  "80fa03f66f4ac627b389b5f82086544f97dfdcdfb02a5f8a85197e7d6d93cd5e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    # Use upstream's CLI to fetch commit-pinned grammars before the offline install.
    ENV["MITOS_DISABLE_AUTO_GRAMMAR_BUILD"] = "1"
    ENV["MITOS_DEFAULT_RUNTIME"] = pkgshare/"runtime"
    system "cargo", "run", "--release", "--locked", "--offline",
           "--package", "term", "--bin", "ms", "--", "--grammar", "fetch", "--strict"
  end

  def install
    ENV["MITOS_DISABLE_AUTO_GRAMMAR_BUILD"] = "1"
    ENV["MITOS_DEFAULT_RUNTIME"] = pkgshare/"runtime"
    system "cargo", "install", *std_cargo_args(path: "crates/term")
    with_env("CARGO_MANIFEST_DIR" => buildpath.to_s) do
      system bin/"ms", "--grammar", "build", "--strict"
    end
    rm_r "runtime/grammars/sources"
    pkgshare.install "runtime"
    bash_completion.install "contrib/completion/ms.bash" => "ms"
    fish_completion.install "contrib/completion/ms.fish"
    zsh_completion.install "contrib/completion/ms.zsh" => "_ms"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ms --version")
    output = shell_output("#{bin}/ms --health rust")
    assert_match(/Tree-sitter parser:.*✓/, output)
    assert_match(/Highlight queries:.*✓/, output)
  end
end
