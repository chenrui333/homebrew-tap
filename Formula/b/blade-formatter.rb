class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.43.0.tgz"
  sha256 "d58ab534b61d005f782cb71ed09eb78181a1231de7f6461f73545909d26172d2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b55150e8fa7aeae6aba5316098d975070a9e2553c44cfcb8e4304ae746eac2eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e94b07b3ac57bd46cb3cc8f8d9da6b0518fe91ab903b4a37eadcbafa18e6a61e"
    sha256 cellar: :any_skip_relocation, ventura:       "f291e3a81ce4178f27135abd4ee4aa1ef8d55a115b7c4a31a564d7aba5244991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f57b0d192d87b53500063249a61c0232c36c3647274529b47f77dbd524eb253e"
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
