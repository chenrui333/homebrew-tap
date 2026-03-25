class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.44.4.tgz"
  sha256 "f71388bf77051936cce72d9ab562d59876b066bbeeac6da7d43a04c654b5d6cd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "829892ef971fcef65d1be610964648e0823169aa03d6f07d289f1c3889ea012a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829892ef971fcef65d1be610964648e0823169aa03d6f07d289f1c3889ea012a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "829892ef971fcef65d1be610964648e0823169aa03d6f07d289f1c3889ea012a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ade2351df5e7b4258fe77c9bfb12bb0304c4484c18700d5b8111082fa0582eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade2351df5e7b4258fe77c9bfb12bb0304c4484c18700d5b8111082fa0582eab"
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
