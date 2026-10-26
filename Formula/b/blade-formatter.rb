class BladeFormatter < Formula
  desc "Opinionated blade template formatter for Laravel that respects readability"
  homepage "https://github.com/shufo/blade-formatter"
  url "https://registry.npmjs.org/blade-formatter/-/blade-formatter-1.44.6.tgz"
  sha256 "e87c904e63d66438678fc86c1472044a5155bb3c4fcad4a67fe4eb94302c2608"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1996c43337e696a925fece62cc34ab745a7444457f2822e97ec4aed8fe64038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1996c43337e696a925fece62cc34ab745a7444457f2822e97ec4aed8fe64038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44485c670fd6e25f0416e10222312db5ad381a4343906c9e019fd6bf0965f58a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44485c670fd6e25f0416e10222312db5ad381a4343906c9e019fd6bf0965f58a"
  end

  depends_on "node"

  deny_network_access!

  # Upstream 1.44.6 devDependencies pin @babel/core ^7 alongside babel v8 plugins,
  # which npm cannot resolve; devDependencies are not needed for the runtime install.
  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devDependencies")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    prepare_package_json
    system "npm", "install", "--offline", *std_npm_args
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
