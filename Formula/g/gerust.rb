class Gerust < Formula
  desc "Project generator for Rust backend projects"
  homepage "https://gerust.rs/"
  url "https://github.com/mainmatter/gerust/archive/refs/tags/0.0.3.tar.gz"
  sha256 "a6ed76805d5f8d2212761eab18623d35dad12276a72dcc51e8860132b9923ca9"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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
