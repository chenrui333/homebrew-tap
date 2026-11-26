class Funes < Formula
  desc "Searchable memory of past AI agent sessions, exposed over MCP"
  homepage "https://github.com/huggingface/funes"
  url "https://github.com/huggingface/funes/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "f01cffc7e99fc3bcd8326e31c2b9180fc6ab3cb47183c70c6ae7232d983cefe2"
  license "Apache-2.0"
  head "https://github.com/huggingface/funes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c339619507d92de4aa7709ac956683f9c77af7711bb618a0371186967b38f5ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40350bc9e6e58994a47bef435fb15c06682db2717f866793bbd207385013896b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "439929bc3026c6064778dd97eb401b98f2fc03f6a3cfa363a8be6bf97978d098"
    sha256 cellar: :any,                 arm64_linux:   "969e2f93051a2a982829363e0bf0f56ceacee2933d3de05de354f716771e6af1"
    sha256 cellar: :any,                 x86_64_linux:  "ea8eef60e780993d9e610b5f4cdc80e02c77936d17018e90fa8a57bf2a06ca15"
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
