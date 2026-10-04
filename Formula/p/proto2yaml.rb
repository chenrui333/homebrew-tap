class Proto2yaml < Formula
  desc "Export Protocol Buffers (proto) files to YAML and JSON"
  homepage "https://github.com/krzko/proto2yaml"
  url "https://github.com/krzko/proto2yaml/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "7a660661d68e92db4c87ec4ea75bd554b8acf9979f62f981eb32b99a0c83e0f1"
  license "MIT"
  head "https://github.com/krzko/proto2yaml.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ce68a96765ff7d519230f1f69c4544a810555a1aac57d562648d627932be830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ce68a96765ff7d519230f1f69c4544a810555a1aac57d562648d627932be830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c8a43a3c7f3d528c8f6f5959917c26f607a9f76e84d24c23e26d1175b06314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec5584fa82322635b05c7cc83cb3e52dcd8fafc97f46a3a9a4fa0a6612b2426d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/proto2yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proto2yaml --version")

    (testpath/"test.proto").write <<~PROTOBUF
      syntax = "proto3";
      package test;
      message TestMessage {
        string name = 1;
        int32 age = 2;
        repeated string hobbies = 3;
      }
      service TestService {
        rpc GetMessage(TestMessage) returns (TestMessage);
      }
    PROTOBUF

    system bin/"proto2yaml", "yaml", "export", "--source", testpath, "--file", "test.yaml"
    output = (testpath/"test.yaml").read
    assert_match "package: test", output
    assert_match "service: TestService", output
    assert_match "name: GetMessage", output
    assert_match "type: unary", output
  end
end
