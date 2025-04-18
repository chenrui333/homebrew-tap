class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v1.69.2.tar.gz"
  sha256 "a6c10a8d0b9a9186db3419075adae497f5fa169113a22a742c05444e711dbaf0"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f8e0941b99b2e95ed6d8e01d11539ca5a2f19d3507cff303d3a71adf1fc4454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40591ab9aa52a2b1ebaeea9f98f3a75770ae2161e7ba0f443f84207c54b28f81"
    sha256 cellar: :any_skip_relocation, ventura:       "6bc743db2bd2e5b3758276f6eb1ed0eac2552b49950fe44926a180f148a5ffbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36b92615bab9fbdff8c2c68d99294971cc52feb41bd9c8b4f7199ce3ea4ec3b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/api-linter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/api-linter --version")

    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;

      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS

    assert_match "message: Missing comment over \"Request\"", shell_output("#{bin}/api-linter proto3.proto 2>&1")
  end
end
