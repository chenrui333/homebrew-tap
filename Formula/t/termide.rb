class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.5",
      revision: "1e06395ba589c83a70dd5d58a0035739fa994792"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfc563ad1a710db31ba56cc8407fea129a98c3a46e848b616d072014d29c9faa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c47766ab673c5232ad065de5e8e1590ccb236264b81d496bf4768a07915f363d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "362d1f932895a2a14e3d3d88abd7d2a25bc992c8f8373d40101b0fd28493b6b5"
    sha256 cellar: :any,                 arm64_linux:   "118631d6cb548a8045d027e90f087019a66808af2e53e34e905b0f2f57593aeb"
    sha256 cellar: :any,                 x86_64_linux:  "691de105d8ed37fb55fb15cecca60282fb2eafe4b013ee9f76bba3d19f7cc129"
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
