class HashaCli < Formula
  desc "Hashing made simple. Get the hash of text or stdin"
  homepage "https://github.com/sindresorhus/hasha-cli"
  url "https://registry.npmjs.org/hasha-cli/-/hasha-cli-7.0.0.tgz"
  sha256 "49d0fe05964de724b5477f2b0800aa796e7e8150732324db0c462c097d3db180"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3d36586edc7e20faa57ae7f71627555718632e4556d81f4a2289832f62693f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a043727a78c0601b2cab4292d83af9e0ad064596b89b91081a9ca09f9e39fe"
    sha256 cellar: :any_skip_relocation, ventura:       "ef1add475ead8b94603a2f3a3bcf083c6515f5ab11cbb8f8ad6902779c6662cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf90ae48025daeb02e022db90e2dd62e96807e8c12b24795cb1feb635658664"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/hasha"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hasha --version")

    output = shell_output("#{bin}/hasha --algorithm sha1 'Hello, world!'")
    assert_equal "943a702d06f34599aee1f8da8ef9f7296031d699", output.chomp

    test_file = testpath/"testfile.txt"
    test_file.write("Hello, world!")
    output = pipe_output("#{bin}/hasha --algorithm sha1", test_file.read)
    assert_equal "943a702d06f34599aee1f8da8ef9f7296031d699", output
  end
end
