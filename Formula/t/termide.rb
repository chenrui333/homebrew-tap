class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.40.0",
      revision: "0719f56e39f6eee4119f53fe40167c4344083fde"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "848f4a882cb939ae4784d05400032ab2a22d2da93138658e0a77550d83f7cf91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed53d2a176d67e4972733c9caa82e9a83f650ad1bebdc12343d61056fba426c5"
    sha256 cellar: :any,                 arm64_linux:   "3c7add7c2a1036ff12494fb90d4e9a46926ca930dfd469debe54eb24d0f7e8d9"
    sha256 cellar: :any,                 x86_64_linux:  "9d49b04074066bca893cf2dae8154183940c130837eb2c01cab39224e26e9b97"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
