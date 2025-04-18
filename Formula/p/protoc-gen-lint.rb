class ProtocGenLint < Formula
  desc "Lint .proto files for style violations"
  homepage "https://github.com/ckaznocha/protoc-gen-lint"
  url "https://github.com/ckaznocha/protoc-gen-lint/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0085935e4e07ad7c341dc09ac8e023da4cbc46981a8da4e95efa354b66dfe49c"
  license "MIT"
  head "https://github.com/ckaznocha/protoc-gen-lint.git", branch: "master"

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;

      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS

    output = shell_output("protoc --lint_out=./ proto3.proto 2>&1", 1)
    assert_match "protoc-gen-lint: unable to determine Go import path", output
  end
end
