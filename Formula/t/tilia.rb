class Tilia < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/mrkkrp/tilia"
  url "https://hackage.haskell.org/package/tilia-0.1.3.0/tilia-0.1.3.0.tar.gz"
  sha256 "c6515319f93d38657b6ad9eb044fb03ee84d92f58cc072eea4aa436d38d15581"
  license "BSD-3-Clause"
  head "https://github.com/mrkkrp/tilia.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b68860c64aaeec2decd8ad2748f6c020c85de05b0173e443ba1f8750eecd3fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e6eb860b764982e6ed0ae36e4b94f2d3d6246ef0d31e3a69b17e5f0aa0cc450"
    sha256 cellar: :any,                 arm64_linux:   "776caaef6aa0b8090d1d9de1f49c3569580988137e710ee432387b89eb72c1b7"
    sha256 cellar: :any,                 x86_64_linux:  "e4ee7ab7b07ce606cbfcd40e0736f5ed5c91b16fa5994d3401fc0208d1a42a80"
  end

  # Tilia consults Cabal build plans and GHC's package database at runtime.
  depends_on "cabal-install"
  depends_on "ghc"
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilia --version")

    (testpath/"cabal.project").write("packages: .\nactive-repositories: none\n")
    (testpath/"test.cabal").write <<~CABAL
      cabal-version: 2.4
      name: test
      version: 0.1.0.0
      build-type: Simple

      library
        exposed-modules: Example
        hs-source-dirs: src
        default-language: Haskell2010
        build-depends: base >=4.14 && <5
    CABAL
    (testpath/"src").mkpath
    source = testpath/"src/Example.hs"
    source.write("module Example where\nvalue=1\n")

    system bin/"tilia", "inplace", "lib:test"
    assert_equal "module Example where\n\nvalue = 1\n", source.read
  end
end
