class Proto2yaml < Formula
  desc "Export Protocol Buffers (proto) files to YAML and JSO"
  homepage "https://github.com/krzko/proto2yaml"
  url "https://github.com/krzko/proto2yaml/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "7a660661d68e92db4c87ec4ea75bd554b8acf9979f62f981eb32b99a0c83e0f1"
  license "MIT"
  head "https://github.com/krzko/proto2yaml.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/proto2yaml"
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
    PROTOBUF

    system bin/"proto2yaml", "yaml", "export", "--source", "test.proto", "--file", "test.yaml"
    assert_match "packages: []", (testpath/"test.yaml").read
  end
end
