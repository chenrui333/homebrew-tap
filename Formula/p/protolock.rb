class Protolock < Formula
  desc "Protocol Buffer companion tool"
  homepage "https://protolock.dev/"
  url "https://github.com/nilslice/protolock/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "81bec7a85a866f1c4c2f361bba718bc2d6ba7dc7e6d662787a44c4e89c0d4b3d"
  license "BSD-3-Clause"
  head "https://github.com/nilslice/protolock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cda4cecd07454883250211e6d22754bca83f5f61eef0affd814027b01ccb42da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cda4cecd07454883250211e6d22754bca83f5f61eef0affd814027b01ccb42da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b40eb65fabde6354e7be5f0c40446bfa90ec1eb930141d625bc34bf5e38a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28593a5718d22358d19292568b88449824821e523e767c2cf459886773e95a69"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
