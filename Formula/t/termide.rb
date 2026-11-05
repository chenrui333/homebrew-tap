class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.49.0",
      revision: "057eb55e0a7c4ee969982fab62dc83bde028e052"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e9a92c7e2224b8bde424357672bf95231eac7af4a5865c267481c6305621ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d588cec8ef3f0f8696bc9f66523cf5c19a8ae26b6572c45b24f8f169a26893f"
    sha256 cellar: :any,                 arm64_linux:   "677e06e7b31061780de99fb5ff846444ce147b42ac8caca9b70a8cf83f42ce51"
    sha256 cellar: :any,                 x86_64_linux:  "eda8ab31098e15381752b88d7097518ae51b40b8c62117e0d9529095a6edf762"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")

    output = shell_output("#{bin}/termide --config #{testpath}/missing.toml --diagnostics 2>&1", 1)
    assert_match "load: config file not found", output
    assert_match "One or more checks failed", output
  end
end
