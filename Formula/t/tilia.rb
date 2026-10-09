class Tilia < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/mrkkrp/tilia"
  url "https://hackage.haskell.org/package/tilia-0.1.0.0/tilia-0.1.0.0.tar.gz"
  sha256 "96c01166b97448aebf1bece78e1afd53d8be4acd3bd8b529c6b6b7a1b1085a48"
  license "BSD-3-Clause"
  head "https://github.com/mrkkrp/tilia.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b53d9a7bf0df87aefad121b4f04c101e3e2a2e0ec131be9c2b9bc7e3988f388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa1750366013242d2dd3750163b2fb428226188c730c2ed414d62f4094f59062"
    sha256 cellar: :any,                 arm64_linux:   "58d8871ba8d95870258ade626c03df6918ccdffc7b5475732712bb7514f7375f"
    sha256 cellar: :any,                 x86_64_linux:  "c1aadc2b14d5d4b65a47c58f6d814693d9fc6a4806b4cdfccda30fba0b4c38b6"
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
