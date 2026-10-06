class Outside < Formula
  desc "Multi-purpose weather client for your terminal"
  homepage "https://github.com/BaconIsAVeg/outside"
  url "https://github.com/BaconIsAVeg/outside/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "012cde0c824c044a15dd3a053b3a84c3d7aeb08f922215e50d70b0e426478de4"
  license "AGPL-3.0-or-later"
  head "https://github.com/BaconIsAVeg/outside.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "767c90c1ffb7d2bb054793a58aca49cdf5f527a5018a2a254247acde8a87c664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edad8dcc4de1fab5168b99c9fddf72057e4ce19853968a381c627a03a65fcf35"
    sha256 cellar: :any,                 arm64_linux:   "23d24580624b520f7e94f5e03bae4dc64da6e9967cf719d9064794d9726eae14"
    sha256 cellar: :any,                 x86_64_linux:  "2e9adc2002342144ca372a340e3adee30eed3bd3bda6e6cdc84beb4da21de739"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    inreplace "Cargo.toml", 'openssl = { version = "0.10", features = ["vendored"] }', 'openssl = "0.10"'

    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/outside --version")

    output = shell_output("#{bin}/outside --stream --output tui 2>&1", 1)
    assert_match "TUI mode cannot be used with streaming mode", output
  end
end
