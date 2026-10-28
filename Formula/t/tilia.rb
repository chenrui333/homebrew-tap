class Tilia < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/mrkkrp/tilia"
  url "https://hackage.haskell.org/package/tilia-0.1.2.0/tilia-0.1.2.0.tar.gz"
  sha256 "c6a88ce6bf89d963877d07c70a4b6386d06d94741b885f4e9566ab7408ad3c50"
  license "BSD-3-Clause"
  head "https://github.com/mrkkrp/tilia.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c61c34a9ae8c7d089de33cad6ddc0e7e7acf547b4d7e136387d969f1519ffaac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d32fc0062dcadd902b5ad6a26ef8b31e10d1a86ad51bcbd19f90e535747fcd3b"
    sha256 cellar: :any,                 arm64_linux:   "86fd52c4b8dbca27522b342f2c3535ad4552359537bad3e066c476ca357e14de"
    sha256 cellar: :any,                 x86_64_linux:  "72f357d894373211ff8530f31ee37f39446f8d8a7886a152303ae66b7b3e5cc3"
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
