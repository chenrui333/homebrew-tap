class Tilia < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/mrkkrp/tilia"
  url "https://hackage.haskell.org/package/tilia-0.0.1.0/tilia-0.0.1.0.tar.gz"
  sha256 "7d086c3bc6b58ad4f781070c80f37c5ae20e2a0840a08512488b538c48336957"
  license "BSD-3-Clause"
  head "https://github.com/mrkkrp/tilia.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2d10e5acf4e501ca0aee8ac5b37755a3087c05a975f06d47ba7f9a0a0255083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caf1da6f7748fbdda911c86b19e3eccfa4f94aafa5f429482f4654f10423914c"
    sha256 cellar: :any,                 arm64_linux:   "9883f0a8f6830c3f9564c07d0694046cd922741821077d3ec7fed04098dfe56a"
    sha256 cellar: :any,                 x86_64_linux:  "6535276161d39d0092d3938cc77a32912ad960c00b3e4dac9b4aaa6f80e0602e"
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
