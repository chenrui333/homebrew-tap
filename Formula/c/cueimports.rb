class Cueimports < Formula
  desc "Updates your import lines, adding missing ones and removing unused ones"
  homepage "https://github.com/asdine/cueimports"
  url "https://github.com/asdine/cueimports/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8437f1118cdb93848cd47db7688bb66889938e66ba4a5eccdeb449a1dfd5f033"
  license "MIT"
  head "https://github.com/asdine/cueimports.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cueimports"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cueimports -version")

    (testpath/"test.cue").write <<~CUE
      package test

      import (
        "encoding/json"
      )

      foo: "bar"
    CUE

    system bin/"cueimports", testpath/"test.cue"

    expected_content = <<~CUE
      package test

      foo: "bar"
    CUE

    assert_equal expected_content, (testpath/"test.cue").read
  end
end
