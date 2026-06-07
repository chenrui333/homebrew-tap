class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.24.0",
      revision: "d6c3cb370512bc5d422cd6984bc454550112f99b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aedbd9f616ee566d4c605edd80a9f075d1a9c32e447f2bb41463e1c7a86f9109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab9e8be52f7945f7193f5a76af051800a35aaffdbdba470b349aa5cc404a6cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cb389bd546b2150fb3b6d71745559378574cb8880a59071eef4bfa68ae820b2"
    sha256 cellar: :any,                 arm64_linux:   "275cb888e8a2bcf5af1cdb62c10c0ec1044bf5145a991fc47acf0a1f4b84da33"
    sha256 cellar: :any,                 x86_64_linux:  "50633e938f6cdfe96243e09c683f0ff90663a3177ac45b8f5104840dc38efb5d"
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
