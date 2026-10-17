class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.41.0",
      revision: "f49a4c40ef6aaaff0741f7a52cefbf163dd9519b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9dddcff4bd83505c1904f5d64f56434a2a92b70919788cce696bd0313ac5604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64df15638e127f12483056db52903a93a411017c7c96cf8f3a1fdd942fb2c58b"
    sha256 cellar: :any,                 arm64_linux:   "a312a9248d6113a3aae71a6ee26f7a4664b89d1600b27d248f34d80ff2b25975"
    sha256 cellar: :any,                 x86_64_linux:  "7ceca7fee729889562e631288c57fa316ac9097fc51f2f0f7fc77dfc7a27ddec"
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
    assert_match "load: config file not found", output
    assert_match "One or more checks failed", output
  end
end
