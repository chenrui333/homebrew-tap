class ProtocGenDoc < Formula
  desc "Documentation generator plugin for Google Protocol Buffers"
  homepage "https://github.com/pseudomuto/protoc-gen-doc"
  url "https://github.com/pseudomuto/protoc-gen-doc/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "75667f5e4f9b4fecf5c38f85a046180745fc73f518d85422d9c71cb845cd3d43"
  license "MIT"
  head "https://github.com/pseudomuto/protoc-gen-doc.git", branch: "master"

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-doc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-doc -version")

    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;

      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--doc_out=.", "--doc_opt=html,index.html", "proto3.proto"
    assert_path_exists testpath/"index.html"
    refute_predicate (testpath/"index.html").size, :zero?
  end
end
