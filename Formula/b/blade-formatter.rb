class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.42.2.tgz"
  sha256 "af46f2340f5076aef1636140c53901228e6b36f6585509a39a0bfa1079cba141"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e47189ad9a990dfe729ee7770b4a3303a90897db6c8539bbd99e47f03a6de18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ffb8fd1f5cd322787b6b608c99bbfd438e4db2eb6362c8149c17856e0fe7928"
    sha256 cellar: :any_skip_relocation, ventura:       "b7477b8626ede7203f927904890a2b9df9988b9029f51bcb6930f6d87103cc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55356aa8202a07c251c0e22e68d45dc8f666fe75b97e94a855dbe563047ec50c"
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
