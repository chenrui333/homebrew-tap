class Protodot < Formula
  desc "Transforming your .proto files into .dot file"
  homepage "https://github.com/seamia/protodot"
  url "https://github.com/seamia/protodot/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c629518cb6a6eb80d5013b04fa7d826ec821c0335e407140350504e47d807f53"
  license "Apache-2.0"
  head "https://github.com/seamia/protodot.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc1276f76a0252e11aed086b1024725b3de0f36d26e33e7c205469e9556eb834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1276f76a0252e11aed086b1024725b3de0f36d26e33e7c205469e9556eb834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7224bd9ac0899372a959fa2cf7545c1fd559dc089a7b960bfd6e1caa4aaef275"
    sha256 cellar: :any,                 x86_64_linux:  "76b7662460e1214bb7b7fccac856de700ef0f2017078766932660c1d80a075c3"
  end

  depends_on "go" => :build
  depends_on "graphviz"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_proto = testpath/"test.proto"
    test_proto.write <<~PROTO
      syntax = "proto3";
      package test;

      message TestMessage {
        string name = 1;
        int32 id = 2;
      }

      message AnotherMessage {
        TestMessage nested = 1;
      }
    PROTO

    system bin/"protodot", "-src", test_proto, "-output", "test"
    assert_path_exists testpath/"protodot/generated/test.dot.svg"
    dot_content = (testpath/"protodot/generated/test.dot").read
    assert_match "digraph", dot_content
  end
end
