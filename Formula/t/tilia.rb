class Tilia < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/mrkkrp/tilia"
  url "https://hackage.haskell.org/package/tilia-0.1.4.0/tilia-0.1.4.0.tar.gz"
  sha256 "0e024104e10c1a02526eecf31f0bf1063d8df423376a0b3511ef6adc862240ae"
  license "BSD-3-Clause"
  head "https://github.com/mrkkrp/tilia.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d557cf49cafb929fe1cf65851e8a181a781e9aeda5eb1200ad7896d2551db62c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36fabee5570740c7f86b1607f4f89d0c17ddc4e713d9c7d536695a6c760848d8"
    sha256 cellar: :any,                 arm64_linux:   "d3d24072ac7a74ee20979ae79999dc7ad1a5c872b7f7eed04e2c00ad49a65398"
    sha256 cellar: :any,                 x86_64_linux:  "aefef3ec7618b158567928ecfd7c26eee209a0ebddaa58c8d551ec4344064496"
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
