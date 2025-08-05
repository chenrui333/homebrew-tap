class Tattoy < Formula
  desc "Text-based compositor for modern terminals"
  homepage "https://github.com/tattoy-org/tattoy"
  url "https://github.com/tattoy-org/tattoy/archive/refs/tags/tattoy-v0.1.8.tar.gz"
  sha256 "bc8a1fbab1870b64faea6494ab202c08c57b062be17fab11d488ecd312963c46"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tattoy")
  end

  test do
    # failed to query terminal's palette
    assert_match version.to_s, shell_output("#{bin}/tattoy --version")
  end
end
