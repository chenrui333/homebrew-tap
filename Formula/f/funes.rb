class Funes < Formula
  desc "Searchable memory of past AI agent sessions, exposed over MCP"
  homepage "https://github.com/huggingface/funes"
  url "https://github.com/huggingface/funes/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "55100de241219b66d1271764be6aa95a0caf1c2663d3d9469eaa40332cdb4682"
  license "Apache-2.0"
  head "https://github.com/huggingface/funes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fcc5c8c470a33526927edea0d9c329c1671b51d5a8e01ce8bf32cf259559616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d03ce166cc66883f3d26a382bf7bc5dcaac5c5f86af6f483e803622287cfb1c"
    sha256 cellar: :any,                 arm64_linux:   "b179d7bf397a9799d12eb3f75f38c6daf8ed614c057496073c16ea6b4fd351e4"
    sha256 cellar: :any,                 x86_64_linux:  "afd27c9f01d0ee6a45bfc05af900ca579720447cb09bbe2865eb753589eb2061"
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
