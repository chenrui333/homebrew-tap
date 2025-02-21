class HashaCli < Formula
  desc "Hashing made simple. Get the hash of text or stdin"
  homepage "https://github.com/sindresorhus/hasha-cli"
  url "https://registry.npmjs.org/hasha-cli/-/hasha-cli-6.0.0.tgz"
  sha256 "ab5264615b9d218dfe8956e7af5a0c1b24a51b0493ca1d13339036968531ada1"
  license "MIT"

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
