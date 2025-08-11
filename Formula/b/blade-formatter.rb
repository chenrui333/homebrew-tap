class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.44.2.tgz"
  sha256 "86c2c12d101cf01113a61778a9b159c26aebd4881efc5cd1f6d86b8b01e0c059"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e6bb6070a72b52aaeb71e7ba4fec895c3e9965c8677b61853fafba4f29b37a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1f5a0ae4f87a17b932e5d207913effcf253a60cfe0bec5d035dc9ec1a3ee35f"
    sha256 cellar: :any_skip_relocation, ventura:       "4c9864ebc707382ae3433d8c5f92aa5b253507eb6a5069d0eee777afed129ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a451dbfdcdf80549f288aea4a6db79b6706e5db1b6bf63972c272f093a46176"
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
