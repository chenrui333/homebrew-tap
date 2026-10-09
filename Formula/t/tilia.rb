class Tilia < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/mrkkrp/tilia"
  url "https://hackage.haskell.org/package/tilia-0.1.0.0/tilia-0.1.0.0.tar.gz"
  sha256 "96c01166b97448aebf1bece78e1afd53d8be4acd3bd8b529c6b6b7a1b1085a48"
  license "BSD-3-Clause"
  head "https://github.com/mrkkrp/tilia.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c56c941887e9010bf3c122efe2c496b2b2d0fa65c503e84343dd6203bdd103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6ae0544e13bd55fd0d2b402b50c440c6a24651df89d7478ff0b7bddb277bc8"
    sha256 cellar: :any,                 arm64_linux:   "6800824c347887248aaf48125d7b8f452835b1420504ec5f2789287f8a3f5e00"
    sha256 cellar: :any,                 x86_64_linux:  "6a16dbee865ddd01ecb2024e67f811957ca107fb1b6cc440c703f2f9fec080bb"
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
