class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.44.1.tgz"
  sha256 "8658f25c67f78e47ef1e37930a650457644a09ff5bdccff05740cf4058d0fd6f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a5e1b2ffbbee2db0eaf4162ac20990b381468f906fb8031f10387f01fe477f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64144ed0d518fe93483de4ea281dfbc7d9fbc65c043b3ae684268300a11ee67f"
    sha256 cellar: :any_skip_relocation, ventura:       "1c8a1f2b891891970890430a365bc4081043656c4f9e7975f94a82f7a83d06b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93423ea7e0bbff348873936338121524637a26f13b7e7d9e1cdd8fbfd63a6714"
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
