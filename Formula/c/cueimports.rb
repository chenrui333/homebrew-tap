class Cueimports < Formula
  desc "Updates your import lines, adding missing ones and removing unused ones"
  homepage "https://github.com/asdine/cueimports"
  url "https://github.com/asdine/cueimports/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8437f1118cdb93848cd47db7688bb66889938e66ba4a5eccdeb449a1dfd5f033"
  license "MIT"
  head "https://github.com/asdine/cueimports.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69ff95f54588692b98fedeb0d9fcd5f733ac3fd4bfee67989c717947535c04f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55f2c6c773be144dc99816940036a5a580dc3ea0bbbb6200d77f536657f2fcab"
    sha256 cellar: :any_skip_relocation, ventura:       "5e79d92713bd94ad0d3eacaaaab20933f9930ebeb9a901d93cc6c7558f9289b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ecdcc65cd2b9338b0678718764790e48039c5f17a838de6b07aceaf932a672"
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
