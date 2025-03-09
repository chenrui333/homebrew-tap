class Protodot < Formula
  desc "Transforming your .proto files into .dot file"
  homepage "https://github.com/seamia/protodot"
  url "https://github.com/seamia/protodot/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c629518cb6a6eb80d5013b04fa7d826ec821c0335e407140350504e47d807f53"
  license "Apache-2.0"
  head "https://github.com/seamia/protodot.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a631d15ef0ac44bdb069967b0eb35ff2501cc439550e9869b629e97d92d06f6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1d1eb6c5f64c4074c4b0e35d3332569728a79c01f6eb9b5ce7f08c0beefd62"
    sha256 cellar: :any_skip_relocation, ventura:       "e5b514baa8a4b7d5120e4c95ba4a68e69b37ae8599a75ece930b1c7e0acac047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a421162f71d5b9c581d87f4572eab35729291e6be3337ac5a818ef3df8900b"
  end

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
