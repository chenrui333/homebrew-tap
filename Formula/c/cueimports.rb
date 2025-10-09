class Cueimports < Formula
  desc "Updates your import lines, adding missing ones and removing unused ones"
  homepage "https://github.com/asdine/cueimports"
  url "https://github.com/asdine/cueimports/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8437f1118cdb93848cd47db7688bb66889938e66ba4a5eccdeb449a1dfd5f033"
  license "MIT"
  revision 1
  head "https://github.com/asdine/cueimports.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "693504383ac3f88e524c59e30e4569d0713c9fce624d152c00c3ad2bdafe4df0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "693504383ac3f88e524c59e30e4569d0713c9fce624d152c00c3ad2bdafe4df0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693504383ac3f88e524c59e30e4569d0713c9fce624d152c00c3ad2bdafe4df0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "805f169d33aed1e99507bd3f9ba8bdcf0481215b2359d773a5c778e1b4ec768d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "121963ee0a0809a2068a55f63bf0cc0a1694d69d82a45a7e2215525e3daf65cd"
  end

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
