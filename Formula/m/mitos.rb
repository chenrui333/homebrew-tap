class Mitos < Formula
  desc "Fast and minimal modal text editor"
  homepage "https://github.com/mitos-editor/mitos"
  url "https://github.com/mitos-editor/mitos/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e203cf8b37fef3a2ddb4fb3154dfabb111d5ae63d1c4679eec6a056e0b1e7839"
  license "MPL-2.0"
  head "https://github.com/mitos-editor/mitos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "c1e7b08a7901c9cac1b32d0cf187d16c07dffc44b88950b42278aaa5b72fa3f0"
    sha256 cellar: :any, arm64_sequoia: "1f52c22079b75d20df16c5cfa1b7d26ceb84a4ec774db6fc97dc139fcf72f6d8"
    sha256 cellar: :any, arm64_linux:   "d2c94a26274695c6446b939b003195f9d3de5f2be3e5e2f431bb6bedd345fde3"
    sha256 cellar: :any, x86_64_linux:  "3134f3992a253e2c3e6f2c7df6b11bc8da924f47667e51066bcd71c45b8676f3"
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
