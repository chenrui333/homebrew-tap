class HashaCli < Formula
  desc "Hashing made simple. Get the hash of text or stdin"
  homepage "https://github.com/sindresorhus/hasha-cli"
  url "https://registry.npmjs.org/hasha-cli/-/hasha-cli-6.0.0.tgz"
  sha256 "ab5264615b9d218dfe8956e7af5a0c1b24a51b0493ca1d13339036968531ada1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28b555d76a765511530cf837e3dd6ef5193d913882057218638f32fff3f227e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0059d582853dd556a5dad2922825039533bf964d6fdb944a2f7f1a3273b1be29"
    sha256 cellar: :any_skip_relocation, ventura:       "4a4c149d132c01b910584093e20dc04c45229fe7e4a1096cca6b1ed4470eae22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf7dbad17221a5a7be6aa58ede1f3d24b6c987cb4278f30241e15fdc6dd0e40c"
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
