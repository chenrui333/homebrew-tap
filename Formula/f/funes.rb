class Funes < Formula
  desc "Searchable memory of past AI agent sessions, exposed over MCP"
  homepage "https://github.com/huggingface/funes"
  url "https://github.com/huggingface/funes/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "6f0562ef6f8767ad871f201f8da71b1366060d3397893263e5cad4fafa4b3707"
  license "Apache-2.0"
  head "https://github.com/huggingface/funes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a9a27d464acc46638decfd7ceb9e2842631da5be3f9543222c0193eb039739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a2fe95fe625261d8cab94f7817439991861f02839725ff8eda3afc2641de3a7"
    sha256 cellar: :any,                 arm64_linux:   "78ae23a164555c99fb33eb7e5b1ea415a58597b428da318159495d71d2c01e70"
    sha256 cellar: :any,                 x86_64_linux:  "764ddfb4d5d028d1b57c2aebcbca0149f4fc0e895096e79496c17b1347751542"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    # Upstream release CI stamps the tag version over the development version.
    inreplace "Cargo.toml", /(\[package\]\nname = "funes"\nversion = )"[^"]+"/, "\\1\"#{version}\""
    inreplace "Cargo.lock", /(name = "funes"\nversion = )"[^"]+"/, "\\1\"#{version}\""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/funes --version")

    output = shell_output("#{bin}/funes sessions --memory local 2>&1", 1)
    assert_match "no index yet", output
  end
end
