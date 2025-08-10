class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.44.1.tgz"
  sha256 "8658f25c67f78e47ef1e37930a650457644a09ff5bdccff05740cf4058d0fd6f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1062c495f217423cd7e51005d36713df81ab61825efa2eba2004130fe32d8d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c0a780fce516aa4bb4e8926de8764e03e598d57cde66d3b31863aaa58ff068"
    sha256 cellar: :any_skip_relocation, ventura:       "b85532324a6c6c2a291efc821dc05a4be051564033c69374af0d1389f163f8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5061881dbb1a68d2f77bc33381dd68e18fa3d039c8c8322758a4b9b48444bde"
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
