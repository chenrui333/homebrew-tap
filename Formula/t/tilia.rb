class Tilia < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/mrkkrp/tilia"
  url "https://hackage.haskell.org/package/tilia-0.1.3.0/tilia-0.1.3.0.tar.gz"
  sha256 "c6515319f93d38657b6ad9eb044fb03ee84d92f58cc072eea4aa436d38d15581"
  license "BSD-3-Clause"
  head "https://github.com/mrkkrp/tilia.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e302f993eafa1c310b18283f9d2f5d7c62e9fa7560de9c97c646baf912ea1c11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4cea715b52ae0388e4ff8bafae26e72346b4156a8dac974a57e2b93242f8990"
    sha256 cellar: :any,                 arm64_linux:   "9c728dd148a563620fe3011a518930592f6684cabc651e2da9b575f0ced50404"
    sha256 cellar: :any,                 x86_64_linux:  "f576a6618c1cb62fa490f1212beb89220ac7f5a866a1864dd2ca70cfa83b7906"
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
