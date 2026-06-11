class Bufisk < Formula
  desc "User-friendly launcher for Buf"
  homepage "https://github.com/bufbuild/bufisk"
  url "https://github.com/bufbuild/bufisk/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ad4ee8d36da378fb0ea492d291d50851d4b68dea1f30f9ad54633a7b24564ecf"
  license "Apache-2.0"
  head "https://github.com/bufbuild/bufisk.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "BUF_VERSION not set", shell_output("#{bin}/bufisk 2>&1", 1)
    assert_match "invalid buf version", shell_output("BUF_VERSION=bad #{bin}/bufisk 2>&1", 1)
  end
end
