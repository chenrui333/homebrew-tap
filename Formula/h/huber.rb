# framework: clap
class Huber < Formula
  desc "Simplify GitHub package management"
  homepage "https://innobead.github.io/huber/"
  url "https://github.com/innobead/huber/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "7648c2840c2747fce2079e19cd57702b573bc03e200400f53125a47f37c4b817"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "2cb201c6f2fc0c36cd8b35aafd148665a7129cf078175f3ea9a35c58036f7034"
    sha256 cellar: :any,                 arm64_sonoma:  "996d0f26257ea8a055adf608b5cf7b7bac514b9c948ef931db5b5c426436a54b"
    sha256 cellar: :any,                 ventura:       "929078ed1c05ec6002ef36c59998b789c6625fa4be7186d7e2d9fee0e04587a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d64eea8709a44547ee0609e89036adb090a7013f3a902d9a72ccf84295fe9108"
  end

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
