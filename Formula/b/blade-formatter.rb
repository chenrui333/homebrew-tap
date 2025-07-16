class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.43.0.tgz"
  sha256 "d58ab534b61d005f782cb71ed09eb78181a1231de7f6461f73545909d26172d2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dca2fcf73fef5d77b6eb38fd668e3e1bba09b9f7b8affab911f08f491906f7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec107037d684c60035a7e6eda6a92068ba542670d02abba267b9d263a77be365"
    sha256 cellar: :any_skip_relocation, ventura:       "8897b13591282c8cae2fcb137dc3ac2deeec2832e8bfd11ab18a9d3550036623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31461a5b55e52f472b023545eedacded76db4cf7bd8f90ee625bf4769e0034c1"
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
