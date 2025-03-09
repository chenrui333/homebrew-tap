class Protolock < Formula
  desc "Protocol Buffer companion tool"
  homepage "https://protolock.dev/"
  url "https://github.com/nilslice/protolock/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "81bec7a85a866f1c4c2f361bba718bc2d6ba7dc7e6d662787a44c4e89c0d4b3d"
  license "BSD-3-Clause"
  head "https://github.com/nilslice/protolock.git", branch: "main"

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
