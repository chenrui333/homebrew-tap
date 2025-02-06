class Flowgger < Formula
  desc "Fast data collector in Rust"
  homepage "https://github.com/awslabs/flowgger"
  url "https://github.com/awslabs/flowgger/archive/refs/tags/0.3.2.tar.gz"
  sha256 "2531d9c6c828091ad17fce54b9f7e0ff8b8417beaf02e06c89757a2adb898999"
  license "ISC"
  head "https://github.com/awslabs/flowgger.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "e0af914d3fc758c871e7e00af9fe8b8c5db4691c1be6cfc2c02e46f67a47aad6"
    sha256 cellar: :any,                 arm64_sonoma:  "b126cfb6e44872b7e480e00418e9bbab4790d75ed5b3153402776d697e056e00"
    sha256 cellar: :any,                 ventura:       "1ba756ca381b69a1e320faee3068be33c02bfa55fc86caa8adc77f1d8c55bd30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1898e8b1d02d1b5b7f544b584b27727526649f605efa2006bbbcbaed048a825"
  end

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
