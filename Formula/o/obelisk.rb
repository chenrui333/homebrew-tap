class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.38.3.tar.gz"
  sha256 "5194206fe0ae41202c4cd38a31e166ef9978da43fa23ad8dbf29c3e828e9aaff"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81bb2ffe1b553b5a7ea6b4ce2bd77af387a201ec8d3e38f141e574ffb59f45c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3d4e9f141e830b12d468a1505c87a901d1b16b8fca2f2cdb38f3cf0e49e9fd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2d943e74eb691524e3d9bde3b5aeff11220b6e8622413388d5cbeb84976a09"
    sha256 cellar: :any,                 arm64_linux:   "510c14a986d9ef7bcea7fe4984ad30532db92a5f17eafa6004d537d91ed57e45"
    sha256 cellar: :any,                 x86_64_linux:  "cbe455f414ac46819ec56698dc74b27fa5a0c274f22e0c1bc5571e5030db4b4a"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
