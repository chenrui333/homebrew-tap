class RfcReader < Formula
  desc "RFC viewer with TUI"
  homepage "https://github.com/ozan2003/rfc_reader"
  url "https://github.com/ozan2003/rfc_reader/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "e58ccf29dc272bcc199c7a9d9418cc6c8aaea78cc7e8680581a5653d17e38350"
  license "MIT"
  head "https://github.com/ozan2003/rfc_reader.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b61d6a58d95f6faa8342859b3e01d5f885fb60373199493fca2470e29e74c32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1128ea940e995e0e7472a1c95edbe4ff11d9d7b960cf40f1638b53606f8bc41"
    sha256 cellar: :any,                 arm64_linux:   "a841ec0ed6456f7df08db6a6502029d6089f309207e1d1211621fd1c2824f59a"
    sha256 cellar: :any,                 x86_64_linux:  "891dbef8c3b112cd64a42251af83538139785383ff2a71a28b8eeca281a4e8e6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rfc_reader --version")
    assert_match "Cache cleared", shell_output("#{bin}/rfc_reader --clear-cache")
  end
end
