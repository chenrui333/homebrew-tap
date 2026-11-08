class Mitos < Formula
  desc "Fast and minimal modal text editor"
  homepage "https://github.com/mitos-editor/mitos"
  url "https://github.com/mitos-editor/mitos/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "8d04e955cae8e1a5d3f39822ae8dbab3ea08903c2ae6787230a675e18bb50349"
  license "MPL-2.0"
  head "https://github.com/mitos-editor/mitos.git", branch: "main"

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
