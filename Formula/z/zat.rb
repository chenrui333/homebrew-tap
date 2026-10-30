class Zat < Formula
  desc "Code outline viewer for LLM coding agents"
  homepage "https://github.com/bglgwyng/zat"
  url "https://github.com/bglgwyng/zat/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "c0891c901b57321223cc00affc20b8bc2fcc08e6c01c20ee977c2cc437c20c9b"
  license "GPL-3.0-only"
  head "https://github.com/bglgwyng/zat.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The tag updates Cargo.toml but leaves the root package version stale in Cargo.lock.
    inreplace "Cargo.lock", /(name = "zat"\nversion = )"0\.5\.3"/, "\\1\"#{version}\""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Older tree-sitter-haskell scanners violate strict aliasing with GCC 16.
    # https://github.com/tree-sitter/tree-sitter-haskell/issues/144
    ENV.append "CFLAGS", "-fno-strict-aliasing" if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    (testpath/"example.rs").write <<~RUST
      pub fn greeting(name: &str) -> String {
          let message = format!("Hello, {}!", name);
          message
      }
    RUST
    output = shell_output("#{bin}/zat example.rs")
    assert_match "greeting", output
    assert_match "L1", output
    refute_match "let message", output
  end
end
