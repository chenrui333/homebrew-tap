class ProtocGenDoc < Formula
  desc "Documentation generator plugin for Google Protocol Buffers"
  homepage "https://github.com/pseudomuto/protoc-gen-doc"
  url "https://github.com/pseudomuto/protoc-gen-doc/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "75667f5e4f9b4fecf5c38f85a046180745fc73f518d85422d9c71cb845cd3d43"
  license "MIT"
  head "https://github.com/pseudomuto/protoc-gen-doc.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "492f4ffdfedd168536904d5f45db3f2f1f3e0b75367e984a519e4f63b684c912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f007ef1922b072fcfc23dec50ea516e05075ad8608ea484b02bc0cff408f242"
    sha256 cellar: :any_skip_relocation, ventura:       "5ec3d9cc8d07d8599e5236a7bcd68eb530b8ecd69d2cb1ab1cf8b8422f0ab1a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ba6e5e8bf0caab5c6965ceccb63320a31259ffd99706231bbc306aac0e48b4"
  end

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
