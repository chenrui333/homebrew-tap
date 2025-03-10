class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-24.1.0.tgz"
  sha256 "ea07d45c0345d80ed76cf9416416bca13fc20606ede90b89d8d2881cbe687ca9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90af4b1493df8e13d9ae5e10ffa49b14619b663d12ef4352b632ef4259fd9082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a4c609f21e35c72d41cbe50e13fb8add74f76f5ba3abbe00ce501b5e312e79"
    sha256 cellar: :any_skip_relocation, ventura:       "cf160ec21a889e5b1d92bd2c66fcb3c7474e74b2fbd4651499acfa80bea1f48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c80045248f1ce775ffa0e18b4c80d6b4c3033c7c7157f297f744f4e08171039d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/ni"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ni --version")

    (testpath/"package.json").write <<~EOS
      {
        "name": "test",
        "version": "1.0.0"
      }
    EOS

    output = pipe_output("#{bin}/ni", "npm\n", 0)
    assert_match "found 0 vulnerabilities", output
    assert_path_exists testpath/"package-lock.json"
  end
end
