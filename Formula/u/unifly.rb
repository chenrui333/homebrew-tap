class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "cd8db5d3bad7c86baa93574f30ec42948a20b1b9991aa50795c459069e67d3c1"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6dbafadcaaf39c09c242cb6f3e48d950131bbc02309d13537464b3010b00f57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "651836b319ffe400da0e874f7139b27de53a6897851e2aebeb3e4eedb6a24c24"
    sha256 cellar: :any,                 arm64_linux:   "7e964103f4c04d1cd24f352efdeb37cc2a246d249aed7b0dfb8ea4aa6d3f84f2"
    sha256 cellar: :any,                 x86_64_linux:  "b3db091371b04f2b130f67122718d6415634f949d8952143e1dfccefc993c1ea"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    (buildpath/".cargo/config.toml").delete if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/unifly")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unifly --version 2>&1")
  end
end
