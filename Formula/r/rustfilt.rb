class Rustfilt < Formula
  desc "Demangle Rust symbol names using rustc-demangle"
  homepage "https://github.com/luser/rustfilt"
  url "https://github.com/luser/rustfilt/archive/refs/tags/0.2.1.tar.gz"
  sha256 "f09bb822c8b22c4c89bf63cc64f8f85a053e1850a70cad4b7308e00871527496"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "663785e8216ecd4dd29beb41e32d34232a175478ce00627ca2c623816542279a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c85486d6ca5ef05989a4f32c774b48121844da996550484f29a8a321b4b6a55"
    sha256 cellar: :any,                 arm64_linux:   "601f52f36587e0b2b42867772844ccef8f5f5e73fe74010d7a92803e31112c97"
    sha256 cellar: :any,                 x86_64_linux:  "3bcf9081fd1dac7123141056b3b2a6cec69239b556882e92fd8cd9e7a5a43b7c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustfilt --version")

    assert_equal "foo::bar::baz", shell_output("#{bin}/rustfilt _ZN3foo3bar3bazE").strip
  end
end
