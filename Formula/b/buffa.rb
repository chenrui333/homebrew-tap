class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "511c626799c4b890b44421ec5d8694924a13153c35a68eefa54bd34031a25bbd"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b65c6fb2cb41347588bc622d8427e18fce34f0cbd6c8057ca6242faa171f04d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ec293b754add9fd5f207fcb26e46a32f0d94df49a66c461567efc00730209fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "977ec2098507852d15414b99ddb6cbb816dd0a4dd91b16cdadb6e53d5d31e23b"
    sha256 cellar: :any,                 arm64_linux:   "487cdeee25852350cb89c0e4fa5cc9d6b734ad3369aa655e8f5cb07895753042"
    sha256 cellar: :any,                 x86_64_linux:  "ca4669a0bb965428ca10ff5d7e086f201018393366361067ebc46e56c420fcd8"
  end

  depends_on "rust" => :build
  depends_on "protobuf"

  def install
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa")
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa-packaging")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-buffa --version")
    assert_match "filter=services", shell_output("#{bin}/protoc-gen-buffa-packaging --help")

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
