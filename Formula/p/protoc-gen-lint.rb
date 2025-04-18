class ProtocGenLint < Formula
  desc "Lint .proto files for style violations"
  homepage "https://github.com/ckaznocha/protoc-gen-lint"
  url "https://github.com/ckaznocha/protoc-gen-lint/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0085935e4e07ad7c341dc09ac8e023da4cbc46981a8da4e95efa354b66dfe49c"
  license "MIT"
  head "https://github.com/ckaznocha/protoc-gen-lint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1c9c3070713d2e8aad114c3c01d90d7edd8e73e80cf18aa8ec3b8fcb49db9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce753c635bbf69d81bfbb2489e985c69353443a2007597f6f1bcf40ecb0e6d96"
    sha256 cellar: :any_skip_relocation, ventura:       "eeabf73dc69ea8093186a777e439454031aa62cf8dd97bbf99481d38ed2bad6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4752782faa507249042aefaddd47c28665c2857a846ae6678d390ec554759f3a"
  end

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
