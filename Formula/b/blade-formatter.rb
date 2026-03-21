class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.44.3.tgz"
  sha256 "56d88e3c93d11f12d3f8a2397db934bf9144dd1f34a16b9e62bf2ddf635a5ad3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882472a84ad6cc1ff21d3ca0586e34eab79d3966e9a5f7c1f0d33cb5127dd8fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "882472a84ad6cc1ff21d3ca0586e34eab79d3966e9a5f7c1f0d33cb5127dd8fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "882472a84ad6cc1ff21d3ca0586e34eab79d3966e9a5f7c1f0d33cb5127dd8fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eaee5b0c3fb8828ff12e337acd67e16e0cd0492a29e2e6a9512360066b435d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eaee5b0c3fb8828ff12e337acd67e16e0cd0492a29e2e6a9512360066b435d8"
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
