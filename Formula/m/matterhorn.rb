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
    url "https://github.com/matterhorn-chat/matterhorn/archive/refs/tags/90000.1.1.tar.gz"
    sha256 "edc87cc58fa5b3bffc1e748c3d4435caf179d2f112998449466212d62d54ae2d"

    # Support the deepseq bundled with current compilers.
    patch do
      url "https://github.com/matterhorn-chat/matterhorn/commit/821bcdf97a6f0ad1263ff25f344ecfa25d2c21ac.patch?full_index=1"
      sha256 "fc0bcd96a40c17673e6b1a7472dfbe1dc55f608861c86dc17ab91bcc42f4770d"
      type :backport
      resolves "https://github.com/matterhorn-chat/matterhorn/issues/860"
    end

    # Prerequisite for upstream's newer dependency compatibility fix.
    patch do
      url "https://github.com/matterhorn-chat/matterhorn/commit/8ffbeff58aa3d7c2c40cbd02943ca371966e6c61.patch?full_index=1"
      sha256 "616b81ec686accdfcd0899bd41252e4f8113c064e62b336c37fda78dbb8c8ca7"
      type :backport
    end

    # Support newer UUID dependencies without forcing an obsolete compiler.
    patch do
      url "https://github.com/matterhorn-chat/matterhorn/commit/a4ac3d88de958891be0c89257f0575ae59d70542.patch?full_index=1"
      sha256 "195ef1559caf6c8986dc1ed1be2fd795dc8f4f2da0fb2ddc7be12e0460b2241f"
      type :backport
    end
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
    system "cabal", "v2-install", "--offline", "--with-compiler=#{formula_opt_bin("ghc@9.12")}/ghc",
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
