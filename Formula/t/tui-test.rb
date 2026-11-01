class TuiTest < Formula
  desc "Control, inspect, test, and record applications in a headless terminal"
  homepage "https://github.com/microsoft/tui-test"
  url "https://github.com/microsoft/tui-test/archive/refs/tags/0.1.1.tar.gz"
  sha256 "ad584f027d387950ffcc18d6039a6a2093871ebfdfe01b4ff3fc76b6048d23af"
  license all_of: ["MIT", "OFL-1.1"]
  head "https://github.com/microsoft/tui-test.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f34aeb89134e217b165d28fd11a4c5f2ec93b02896b1ea59f164bbf976533d8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bac4d005d28a5daca8fc3d5f6ff40366b875dcf3b736deaaba9cf655461a544"
    sha256 cellar: :any,                 arm64_linux:   "95d1e5b0478d881633b9859c8a9e97867094a721e7af964f87f90d802bdb8edf"
    sha256 cellar: :any,                 x86_64_linux:  "25fbd1c2c2d42291d47c14c94e493d61d03217232c928a69f79f2a0aee9a7929"
  end

  depends_on "rust" => :build
  depends_on "zig@0.16" => :build

  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty/archive/22d13172cde98a0a4dda05d3d6a3fcb0dd8ed018.tar.gz"
    sha256 "5fdb21d3744ce76dfaefb0e25fd113540906939752627a4193b88520e126c389"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    resource("ghostty").stage buildpath/"ghostty"
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    cd "ghostty" do
      system "zig", "build", "--fetch=all", "-Demit-lib-vt=true", "-Dapp-runtime=none",
                    "-Demit-xcframework=false"
    end
  end

  def install
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    ENV["GHOSTTY_SOURCE_DIR"] = buildpath/"ghostty"
    # Keep the CLI's Ghostty, Rio, xterm.js, and bundled recording-font features.
    # The immutable source archive includes the MIT xterm.js bundles and licensed font assets.
    system "cargo", "install", *std_cargo_args(path: "crates/tui-test-cli")
    pkgshare.install "crates/tui-test/assets"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tui-test --version")
    ENV["TUI_TEST_SESSION"] = "homebrew"
    begin
      system bin/"tui-test", "open", "--shell", "bash", "--backend", "ghostty"
      system bin/"tui-test", "submit", "printf 'homebrew-terminal-%s\\n' ready"
      system bin/"tui-test", "expect", "text", "homebrew-terminal-ready", "--timeout", "10000"
      assert_match "homebrew-terminal-ready", shell_output("#{bin}/tui-test text")
    ensure
      system bin/"tui-test", "--session", ENV.fetch("TUI_TEST_SESSION"), "daemon", "stop"
    end
  end
end
