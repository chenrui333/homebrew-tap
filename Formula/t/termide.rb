class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide/archive/refs/tags/0.20.1.tar.gz"
  sha256 "a50dcbc3bdda96dedf97f5d043e84a0c2923191b3004efa5ad03a64669893edc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b6b8df50f2a995f0f55dd667fd7ec9c36a72454a62303a952930d90c357864bb"
    sha256                               arm64_sequoia: "d5f0c838e8fc34a541a682a3c7ce5d5d39dce94e32e23ad42d5ace7b50fa7c5f"
    sha256                               arm64_sonoma:  "3fcc78a582efbd2dfefa442a5550d23cca0f5665e0000ee3e09ab8f14080cbdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "741afdb6ef34a46b27e43e33f4386ba03096000a45829919ea7619871f7e5ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe21b332b3eed6857b816f93435b09c4a779b2cb1d1acf249bf0d599a7bb9775"
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
