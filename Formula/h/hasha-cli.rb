class HashaCli < Formula
  desc "Hashing made simple. Get the hash of text or stdin"
  homepage "https://github.com/sindresorhus/hasha-cli"
  url "https://registry.npmjs.org/hasha-cli/-/hasha-cli-7.0.0.tgz"
  sha256 "49d0fe05964de724b5477f2b0800aa796e7e8150732324db0c462c097d3db180"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f9d9fdd4470989198d2d8f4d268d068a315b00ac4dde507199fb17b112cc997b"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
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
