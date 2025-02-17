# framework: clap
class Huber < Formula
  desc "Simplify GitHub package management"
  homepage "https://innobead.github.io/huber/"
  url "https://github.com/innobead/huber/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "7648c2840c2747fce2079e19cd57702b573bc03e200400f53125a47f37c4b817"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "huber")
  end

  test do
    require "utils/linkage"

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"huber", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
