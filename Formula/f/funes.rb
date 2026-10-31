class Funes < Formula
  desc "Searchable memory of past AI agent sessions, exposed over MCP"
  homepage "https://github.com/huggingface/funes"
  url "https://github.com/huggingface/funes/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "c5f5ba5487b5b2f9d8145d4dfbcc2cb955bfbc564075e1d69978b0bf5cbe2207"
  license "Apache-2.0"
  head "https://github.com/huggingface/funes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e708c0d90f80ac033c9bb962fe1485191833392973469e990f5bf8c90aa93ea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e629661432bb1f44e8660606bac4a5be6c63f7614b2769d30866e008e6b6937e"
    sha256 cellar: :any,                 arm64_linux:   "c49ab8869842c83068bad8b9651764f2eeeef33f9b2b35b1cd5d47d1e8d2138b"
    sha256 cellar: :any,                 x86_64_linux:  "45fc758d13a653ea25230e3e0abd8e88e8400cc273889b700008edd45ebd8a34"
  end

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
