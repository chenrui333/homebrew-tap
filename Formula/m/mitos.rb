class Mitos < Formula
  desc "Fast and minimal modal text editor"
  homepage "https://github.com/mitos-editor/mitos"
  url "https://github.com/mitos-editor/mitos/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e203cf8b37fef3a2ddb4fb3154dfabb111d5ae63d1c4679eec6a056e0b1e7839"
  license "MPL-2.0"
  head "https://github.com/mitos-editor/mitos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "8787cf99c376a56cf4a422bacec22c2547c8ac90f9d5b0a659750eb7ddef0aec"
    sha256 cellar: :any, arm64_sequoia: "a4f7354eb90c2d4166e74cebd924ab15ae9ea8cd662803ab185241d984c27f42"
    sha256 cellar: :any, arm64_linux:   "c9d185ee0d7cdb0d0650d710d386874ed91113845db985a91b224911235980e2"
    sha256 cellar: :any, x86_64_linux:  "727e1e7104cae343fca2180d476ab8f378c6a3a7fd4f3a1f1b54bbb204df6855"
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
