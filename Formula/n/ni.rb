class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-25.0.0.tgz"
  sha256 "286539e8266320af65eae40059ceb83885a8df5bfc530c7c025e19c593558984"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52211ba97226cb0eca3d4c01e50ec1b6e91d587bddf4cc17703be3b7629affb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3301a96027d440113680b4db9b09f75c11e65a000791c4320c04b7cf24742f2e"
    sha256 cellar: :any_skip_relocation, ventura:       "a7cd9bc4a08d76aff73ad1c7e3fbd4c4b8cf205ad936947c23d76bd2e38875eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18dc99f568f6e067f9ce990a2cd0287170774a91dcaf936d75b61270892973ee"
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
