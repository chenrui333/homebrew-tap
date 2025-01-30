class Ezkl < Formula
  desc "Cross-platform, OpenGL terminal emulator"
  homepage "https://github.com/zkonduit/ezkl"
  url "https://github.com/zkonduit/ezkl/archive/refs/tags/v18.1.5.tar.gz"
  sha256 "6894fc4b2851f3bcfc124f85690b2e6c40ef1f3d2cab970572612b79d2431eea"
  # license :unfree

  depends_on "pkgconf" => :build
  depends_on "rustup" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "component", "add", "rustfmt", "clippy"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ezkl", "--version"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"gerust", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
