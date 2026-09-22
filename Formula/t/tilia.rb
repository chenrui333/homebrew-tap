class Tilia < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/mrkkrp/tilia"
  url "https://hackage.haskell.org/package/tilia-0.0.1.0/tilia-0.0.1.0.tar.gz"
  sha256 "7d086c3bc6b58ad4f781070c80f37c5ae20e2a0840a08512488b538c48336957"
  license "BSD-3-Clause"
  head "https://github.com/mrkkrp/tilia.git", branch: "master"

  # Tilia consults Cabal build plans and GHC's package database at runtime.
  depends_on "cabal-install"
  depends_on "ghc"
  depends_on "gmp"

  uses_from_macos "libffi"

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
