class Gerust < Formula
  desc "Project generator for Rust backend projects"
  homepage "https://gerust.rs/"
  url "https://github.com/mainmatter/gerust/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "1036cc5461e91f775bf499575f2352cba8a91ac2c97d2b312bdc19601d300038"
  license "MIT"
  head "https://github.com/mainmatter/gerust.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "8ad04b29400bc0a8442ab549070b1fe5a86e2a927273db50c8c12bda3d5861f7"
    sha256 cellar: :any,                 arm64_sonoma:  "b3dcfcbb8635ecadca0372f950e4d01ed4b3272d741736ae1722f6dde43cfc9c"
    sha256 cellar: :any,                 ventura:       "f8b4dbed14f86f8eadbccdd02fb2cdebfaf169b0d4e9b3b4b4a2a628c95551af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a6ee65231481758255c176f86a5f08a2cd2b9793a1d89d23779969984af2e4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/gerust --version")

    (testpath/"brewtest").mkpath
    output = shell_output("#{bin}/gerust brewtest --minimal 2>&1")
    assert_match "Could not generate project!", output

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"gerust", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
