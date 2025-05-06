class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.13.tgz"
  sha256 "840fdacd28659c06c9a9338996f6e1c9b83e4cf27dd9216902757b232ccd8348"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0e9aae1f82bc88b7225de09570f1f2c820fbf326a10ab2b0f34ae4cb5f6ab7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5618cdc0552caeda82614e878606b253bcca0b402290677f3cc57d90adae9df3"
    sha256 cellar: :any_skip_relocation, ventura:       "8c14f22b3059cb102cb27f93460627bfb2ee6c0cbd3c673ae75cfdf5bff046fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96910e9c82eadd19e553523d9f29a9de0cc941be4272131704a6a4df69cbbe25"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/brighterscript-formatter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brighterscript-formatter --version")

    (testpath/"test.bs").write <<~BRIGHTERSCRIPT
      sub Main()
      print "Hello, World!"
      end sub
    BRIGHTERSCRIPT

    system bin/"brighterscript-formatter", "--write", testpath/"test.bs"

    expected_content = <<~BRIGHTERSCRIPT
      sub Main()
          print "Hello, World!"
      end sub
    BRIGHTERSCRIPT

    assert_equal expected_content, (testpath/"test.bs").read
  end
end
