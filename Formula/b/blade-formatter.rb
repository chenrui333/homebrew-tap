class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.42.4.tgz"
  sha256 "350460597e1d402fdd1ab8996b808b3e9042217fd1ade2b80c2ea35158c9cc5d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e1675dc8f326339ec2358c2e1062a7dbfdc077d95f269c1bb2c1f210a378a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b333e5a18e6ea0d617878e3044edd29f5265cd8f5d27a8ff5ff75928e0527fd"
    sha256 cellar: :any_skip_relocation, ventura:       "c4354a3d3820369fb41d049798c2a50c1477cb1633e4bd7f62b91c60bec32da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a69c4d1b772ee73f1ee9346990b613f0a9a79f7116e60916598277fe29e1e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/blade-formatter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blade-formatter --version")

    (testpath/"test.blade.php").write <<~BLADE
      <div>
      @if (true)
      <p>Hello, World!</p>
      @endif
      </div>
    BLADE

    system bin/"blade-formatter", "--write", "test.blade.php"
    expected_content = <<~BLADE
      <div>
          @if (true)
              <p>Hello, World!</p>
          @endif
      </div>
    BLADE

    assert_equal expected_content, (testpath/"test.blade.php").read
  end
end
