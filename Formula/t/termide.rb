class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.35.0",
      revision: "b1400585e2aeadca23b6b86a86010e612e3dddae"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7123f83ef4d13ebecf1c68b6b1787ed6cc0bd232deebc45fcf42b5fa4de52be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbbd00aa85bdab7fdb283a6d2797e35e228d6440271cbd2fc064ee77a2b9cb7e"
    sha256 cellar: :any,                 arm64_linux:   "4f4d98344ebe273a116a33e9efe8e79cabbb16e3d807e59d49eff564b18634a8"
    sha256 cellar: :any,                 x86_64_linux:  "ee162026676f20929fcf87d656089c28189461bf33feb42860d542fd9a6d8851"
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

    output = shell_output("#{bin}/termide --config #{testpath}/missing.toml --diagnostics 2>&1", 1)
    assert_match "load: No such file or directory", output
    assert_match "One or more checks failed", output
  end
end
