class Funes < Formula
  desc "Searchable memory of past AI agent sessions, exposed over MCP"
  homepage "https://github.com/huggingface/funes"
  url "https://github.com/huggingface/funes/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "c5f5ba5487b5b2f9d8145d4dfbcc2cb955bfbc564075e1d69978b0bf5cbe2207"
  license "Apache-2.0"
  head "https://github.com/huggingface/funes.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    # Upstream release CI stamps the tag version over the development version.
    inreplace "Cargo.toml", 'version = "1.9.0+dev"', "version = \"#{version}\""
    inreplace "Cargo.lock", /(name = "funes"\nversion = )"1\.9\.0\+dev"/, "\\1\"#{version}\""
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
