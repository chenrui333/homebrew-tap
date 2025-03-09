class Protolock < Formula
  desc "Protocol Buffer companion tool"
  homepage "https://protolock.dev/"
  url "https://github.com/nilslice/protolock/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "81bec7a85a866f1c4c2f361bba718bc2d6ba7dc7e6d662787a44c4e89c0d4b3d"
  license "BSD-3-Clause"
  head "https://github.com/nilslice/protolock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebeb944c95406f31df93ac9be4b1d0dc27d1ae4bb618e5d7e0df8110af4a9219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c931e6a053e6ef6acd093a10536cf5aafb8b5f8aeeaf1c6423112bbf41c9058"
    sha256 cellar: :any_skip_relocation, ventura:       "fd58528c57cfa0439867846753d28539222953c8f116f1665c007d09f257e577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67181a874b5d9d2f53fe45383180b228f44051a6c77b468aece93ca1d0ac948"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protolock"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      package test;

      message TestMessage {
        string name = 1;
        int32 id = 2;
      }
    EOS

    system bin/"protolock", "init", "--lockdir", testpath
    assert_path_exists testpath/"proto.lock"

    system bin/"protolock", "status"
  end
end
