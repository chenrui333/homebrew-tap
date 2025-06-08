class Proto2yaml < Formula
  desc "Export Protocol Buffers (proto) files to YAML and JSON"
  homepage "https://github.com/krzko/proto2yaml"
  url "https://github.com/krzko/proto2yaml/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "7a660661d68e92db4c87ec4ea75bd554b8acf9979f62f981eb32b99a0c83e0f1"
  license "MIT"
  head "https://github.com/krzko/proto2yaml.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30b70984aaa6897670a8b09a48b307ab5c2011618e3355935c900ee7fcb5485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f55c2a250a9744f85462049a791b499ec659757fb867aa7c178a7cfd4b69f9"
    sha256 cellar: :any_skip_relocation, ventura:       "f8921a0bb025370e83c4cb0a3a6746f2dc44f0381b523e1a5726d835b4da29b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5147735431a6ca833a57a9e7a237bd6aa721e76be37d6c364387ef05dd65e2b5"
  end

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
