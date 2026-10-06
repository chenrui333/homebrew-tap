class ProtocGenLint < Formula
  desc "Lint .proto files for style violations"
  homepage "https://github.com/ckaznocha/protoc-gen-lint"
  url "https://github.com/ckaznocha/protoc-gen-lint/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0085935e4e07ad7c341dc09ac8e023da4cbc46981a8da4e95efa354b66dfe49c"
  license "MIT"
  head "https://github.com/ckaznocha/protoc-gen-lint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "786bdc2f45f7f4d765e3faf2358bbb4b3146684983fc314433741f3d9f3f3b63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "786bdc2f45f7f4d765e3faf2358bbb4b3146684983fc314433741f3d9f3f3b63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6237fcac530c8393fa9aec45593deb93ce6ffd2da220fac6a8c056fd4ecd2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8334b7f14d9268b3a16e02eb176109db9aed27f465cc2ef430d7bcf78b00680"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  deny_network_access!

  def install
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: "-s -w")
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
