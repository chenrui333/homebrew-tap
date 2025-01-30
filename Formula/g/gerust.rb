class Gerust < Formula
  desc "Project generator for Rust backend projects"
  homepage "https://gerust.rs/"
  url "https://github.com/mainmatter/gerust/archive/refs/tags/0.0.3.tar.gz"
  sha256 "a6ed76805d5f8d2212761eab18623d35dad12276a72dcc51e8860132b9923ca9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "25b1bc9bc55b2a05af162eab440beac5ac3befc62e6ac7c41934f8f7e85581e4"
    sha256 cellar: :any,                 arm64_sonoma:  "7de5d9baa32407a3d31a20ed2a60d0324a9867b752ed34af5b92fc34f57ede7d"
    sha256 cellar: :any,                 ventura:       "86e300fb7ac40493d61ac01ac3630a2b936f0dcf51bcf20327742b902ead3791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7008e273346784f93a34ed47cf647d3d6a848661037aa522ae5134f8e415ac9"
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
