# framework: clap
class Huber < Formula
  desc "Simplify GitHub package management"
  homepage "https://innobead.github.io/huber/"
  url "https://github.com/innobead/huber/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "7648c2840c2747fce2079e19cd57702b573bc03e200400f53125a47f37c4b817"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b765d154c3a4bfd8c9fcf5ceb79407e4d4008f820c1cf5ee1b380e47019acbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec31cffb06ad7039a938c68bb8f104c2dad98adfb9ee286d1d1f99b23fb6cfb"
    sha256 cellar: :any,                 arm64_linux:   "a00537ea21250bd2332db678bf3dfac61aa6beeb8fca6e85f05b42ca4b28514d"
    sha256 cellar: :any,                 x86_64_linux:  "6f6badc5c0c165e3e3ac86f55b4512d7c95eebb08405fe2da6cd7bc1b410ec79"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "huber")
  end

  test do
    require "utils/linkage"

    [
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"huber", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
