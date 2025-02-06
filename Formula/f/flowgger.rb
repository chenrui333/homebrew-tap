class Flowgger < Formula
  desc "Fast data collector in Rust"
  homepage "https://github.com/awslabs/flowgger"
  url "https://github.com/awslabs/flowgger/archive/refs/tags/0.3.2.tar.gz"
  sha256 "2531d9c6c828091ad17fce54b9f7e0ff8b8417beaf02e06c89757a2adb898999"
  license "ISC"
  head "https://github.com/awslabs/flowgger.git", branch: "master"

  depends_on "capnp" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/flowgger --version")

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"flowgger", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
