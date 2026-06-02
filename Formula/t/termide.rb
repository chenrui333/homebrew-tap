class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.5",
      revision: "1e06395ba589c83a70dd5d58a0035739fa994792"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00f80a1b5ae1087546b6100db7cc5c28853140ca713af635420fd45b6c9aa59d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ec40ed7d0996815283906e97cfc73d29a3430f3290afdb60216e1875de6a298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bc87638a9e3dc8f3f07f82cfa504318fb9c8431a9af73308cb9f7e46338720e"
    sha256 cellar: :any,                 arm64_linux:   "7078b16b5be98bccb61dc2c59d365c6eb0bf161b740a669af564939014bcad9b"
    sha256 cellar: :any,                 x86_64_linux:  "44d66fe6f08d03893d1f2ad4a0f816ddc347ce2d3cd65a62f3d94a4f457549b5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")
  end
end
