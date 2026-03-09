class Outside < Formula
  desc "Multi-purpose weather client for your terminal"
  homepage "https://github.com/BaconIsAVeg/outside"
  url "https://github.com/BaconIsAVeg/outside/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "012cde0c824c044a15dd3a053b3a84c3d7aeb08f922215e50d70b0e426478de4"
  license "AGPL-3.0-or-later"
  head "https://github.com/BaconIsAVeg/outside.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "Cargo.toml", 'openssl = { version = "0.10", features = ["vendored"] }', 'openssl = "0.10"'

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/outside --version")

    output = shell_output("#{bin}/outside --stream --output tui 2>&1", 1)
    assert_match "TUI mode cannot be used with streaming mode", output
  end
end
