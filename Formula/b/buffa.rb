class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "511c626799c4b890b44421ec5d8694924a13153c35a68eefa54bd34031a25bbd"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caae0e1456eef19dcc1c3a945892154d0fa32db373e0435b2b0e345343d1342c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ab6de5169ec366bf89c98935268d40c61e4440220e59407c2c1abb3f7b0188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6b12d0018359f2def6e2eb14b73a11ad6b042f86d9b6bddbe16ec27be676c32"
    sha256 cellar: :any,                 arm64_linux:   "840a0b5c15ea4c8d694fb44b459a95219683b9af726b7fe8b85de066ab8dd0b4"
    sha256 cellar: :any,                 x86_64_linux:  "1fa5ab60cf9f4beba033c604c7f667edf89bdcb143354a9b70ecdc0b127eb218"
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
