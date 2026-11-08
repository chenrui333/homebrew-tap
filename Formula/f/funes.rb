class Funes < Formula
  desc "Searchable memory of past AI agent sessions, exposed over MCP"
  homepage "https://github.com/huggingface/funes"
  url "https://github.com/huggingface/funes/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "57a6452685c501e739ee63664f17145c313ec49c2bce171c269cc7990aa38cfd"
  license "Apache-2.0"
  head "https://github.com/huggingface/funes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a46ca2711728fc2cb970130e0ef02dea8062f167137f90880fa824ffdda1ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a28621bd973b94ee5bf01c998ca1919695632fe7d23c1c0ab5bf1ccc582333ed"
    sha256 cellar: :any,                 arm64_linux:   "ca9c789cf8cd8633852e5fa999ab627e46a98980107f28bf01ea5ea56f361082"
    sha256 cellar: :any,                 x86_64_linux:  "855a62644eb4f9620306b6fd9df9f0b93b45ed3d1f34ab43157d7cda91096089"
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
