require "download_strategy"

# API libraries are built from Hackage instead of upstream's SSH-only submodules.
class MatterhornGitDownloadStrategy < GitDownloadStrategy
  def submodules?
    false
  end
end

class Matterhorn < Formula
  desc "Terminal client for the Mattermost chat system"
  homepage "https://github.com/matterhorn-chat/matterhorn"
  license "BSD-3-Clause"
  head "https://github.com/matterhorn-chat/matterhorn.git", branch: "develop", using: MatterhornGitDownloadStrategy

  stable do
    url "https://github.com/matterhorn-chat/matterhorn/archive/refs/tags/90000.1.2.tar.gz"
    sha256 "aaa649015f4a62f29ff86504d4165994d708c0ec852b0c0f1f3b203656c12630"

    # Support newer UUID dependencies without forcing an obsolete compiler.
    patch do
      url "https://github.com/matterhorn-chat/matterhorn/commit/a4ac3d88de958891be0c89257f0575ae59d70542.patch?full_index=1"
      sha256 "195ef1559caf6c8986dc1ed1be2fd795dc8f4f2da0fb2ddc7be12e0460b2241f"
      type :backport
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "873e412a9525d7e0bc9d18a993a95716d717c98f342ac5fb3abddb6b7a8937cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c76bb07df2ae399bc086e1a0f1ceca200b4a443423787ea3cd5504177eca33f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "637459c823e4e25618eedf0cb79fcfda69ee339431122adacb5beb2fb84a78f2"
    sha256 cellar: :any,                 arm64_linux:   "d42a6c779e9dbbce2735e0b5522a84c9997df56c7eb0537fb4dbd6a7e074c0b8"
    sha256 cellar: :any,                 x86_64_linux:  "6c6bd3b98fd6541b342d17b4c966df33b497188f843c6a321375209c85455601"
  end

  depends_on "cabal-install" => :build
  # Brick 2.8 requires base < 4.22, which excludes GHC 9.14.
  depends_on "ghc@9.12" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    # Upstream documents removing this file when building release tarballs.
    rm "cabal.project"
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", "--with-compiler=#{formula_opt_bin("ghc@9.12")}/ghc",
                    *std_cabal_v2_args(installdir: libexec), "exe:matterhorn"
  end

  def install
    # Cabal's --offline rejects cached Hackage sources; Homebrew's build sandbox enforces offline access.
    system "cabal", "v2-install", "--with-compiler=#{formula_opt_bin("ghc@9.12")}/ghc",
                    *std_cabal_v2_args(installdir: libexec), "exe:matterhorn"
    # Matterhorn discovers release data beside its executable.
    libexec.install "emoji", "syntax"
    bin.install_symlink libexec/"matterhorn"
    doc.install "docs", "client-scripts", "notification-scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/matterhorn --version")

    (testpath/"invalid.ini").write <<~INI
      [mattermost]
      channelListOrientation = sideways
    INI
    output = shell_output("#{bin}/matterhorn --config #{testpath}/invalid.ini --check-config 2>&1", 1)
    assert_match "Invalid value for channelListOrientation", output
  end
end
