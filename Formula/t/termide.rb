class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.29.0",
      revision: "228ad5c88ae3074015ebfc09a01c663cabd6e9db"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30e708605b536cf7013e34b9fecd634cce4296012d88899bedb0ffb08a245e46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c927790e1941e36ae3c42c3ef8d74aabb113cb236eba2fd603cfe57a69b2696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64e9fc9bf06034d53f0621c93e531b4df6ccbb088ef596fe7e60d26d658b7102"
    sha256 cellar: :any,                 arm64_linux:   "32df6d51723c1b362f2af4227c30343a92152d133b922d3e30c7b3016706b466"
    sha256 cellar: :any,                 x86_64_linux:  "f6956839ecb6e785ad47c20cf04868f090f491cea6585511855c0c80b26be738"
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
