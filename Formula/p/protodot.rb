class Protodot < Formula
  desc "Transforming your .proto files into .dot file"
  homepage "https://github.com/seamia/protodot"
  url "https://github.com/seamia/protodot/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c629518cb6a6eb80d5013b04fa7d826ec821c0335e407140350504e47d807f53"
  license "Apache-2.0"
  head "https://github.com/seamia/protodot.git", branch: "master"

  depends_on "go" => :build
  depends_on "graphviz"

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
