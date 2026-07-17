class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "185771400b27c64ea7b93a7af204c771ce418cb720e540e79e8c5a21ede96f99"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfc9e8de084ead54e2b19346ee5194cfc85d3918f31ffab49d53269fd761bdeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6932863adc6fd204aff0cce26c2eb5798a1cd58b737817ab0b1351b2fbc6ceb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fd603289d41dc920804c8b7f54be610112f3bb2a86e0f24746a80e9ef3f027c"
    sha256 cellar: :any,                 arm64_linux:   "871c321967ecd8d024f0fac1a200aaa58df14b9362aedf01b70452145ec71178"
    sha256 cellar: :any,                 x86_64_linux:  "f7dbbff80d3ab3fe8b0f540bc35135d3ce02b9458e29927ac75f59fee42576cd"
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
