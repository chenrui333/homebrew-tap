class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "923f9c96a8bd8bbb62f53ca7893ac2a86403e5f40bc0593a36e2ffcc62706b82"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74697d6103737b588d5de1f7768096177c0f1a8ecbf443526ee4b773db1665c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a74ab7252ebdce35a6a964b566cf9800d05508690412242276453ecaf9f4de26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e07268d9e50af1b64fac82a83d45bca9e5397c81e771877b6f59805401867c07"
    sha256 cellar: :any,                 arm64_linux:   "044d9640bb1d6ae02992d149c2be0a2e1fb66037c50c7b240494ff5fa405e917"
    sha256 cellar: :any,                 x86_64_linux:  "b25955c3de7b57035b2fb526865c963a7cfd7b5592ff1d96d7157a7c90f0f372"
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
