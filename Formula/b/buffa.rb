class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "318b363643469c50517cabed7e28c8950f895457b1165fca84f09ca884121d49"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0060f2d94929342253bf0bb8369176d675b96ef08eb4e909d2512b8fc82e2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6c335a9c53137f12191e8c81a32b536db7b856b6ce1056c3fe5cbe35dad3c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b16208e602a52c9207bb6b7909d46547507952baa4686567127e3020315eee91"
    sha256 cellar: :any,                 arm64_linux:   "1b6144541580ad7057f858bc17559eca5bc1f3d1664c367165e5acbeb8d9581b"
    sha256 cellar: :any,                 x86_64_linux:  "786ee000e697d81785d00ea9d5bbe70b467096a4334cc3aee2df0e75da83154a"
  end

  depends_on "rust" => :build
  depends_on "protobuf"

  def install
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa")
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa-packaging")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-buffa --version")

    (testpath/"sample.proto").write <<~PROTO
      syntax = "proto3";
      package example.v1;

      message Greeting {
        string message = 1;
      }
    PROTO

    (testpath/"gen").mkpath
    system "protoc",
           "--plugin=protoc-gen-buffa=#{bin}/protoc-gen-buffa",
           "--plugin=protoc-gen-buffa-packaging=#{bin}/protoc-gen-buffa-packaging",
           "--buffa_out=gen",
           "--buffa-packaging_out=gen",
           "sample.proto"

    assert_match "pub struct Greeting", (testpath/"gen/sample.rs").read
    assert_match "pub mod example", (testpath/"gen/mod.rs").read
  end
end
