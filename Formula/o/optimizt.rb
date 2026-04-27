class Optimizt < Formula
  desc "CLI image optimization tool"
  homepage "https://github.com/343dev/optimizt"
  url "https://registry.npmjs.org/@343dev/optimizt/-/optimizt-12.1.1.tgz"
  sha256 "eb7fbfe1cacbc61eecf9fa598d4e09d25448827246e00a999553da779ba4d1d2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c4e73326dbf149667b1f3c71915c81fe06af45dc2a6d3b5c76c5c4ad152e47fa"
    sha256 cellar: :any,                 arm64_sequoia: "7d427c5c4e44b5e0674fd8c21ce21991c2b3c380eb5c0c308965c0828adf6bd8"
    sha256 cellar: :any,                 arm64_sonoma:  "7d427c5c4e44b5e0674fd8c21ce21991c2b3c380eb5c0c308965c0828adf6bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d6ee49f8237d55234244320114f6314181afadee17afd0ff10cb9ed4a71d400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70f5be2bb3106d9b2b945a7df97977b98e8e7bc43f821521d36fac4eabecc982"
  end

  depends_on "gifsicle"
  depends_on "guetzli"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/@343dev/optimizt/node_modules"
    {
      "@343dev/gifsicle" => Formula["gifsicle"].opt_bin/"gifsicle",
      "@343dev/guetzli"  => Formula["guetzli"].opt_bin/"guetzli",
    }.each do |package_name, binary_path|
      package_dir = node_modules/package_name
      rm package_dir/"index.js"
      (package_dir/"index.js").write "export default #{binary_path.to_s.inspect};\n"
      rm_r package_dir/"vendor"
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/optimizt --version")

    cp test_fixtures("test.png"), testpath/"test.png"
    output = shell_output("#{bin}/optimizt test.png")
    assert_match "Optimizing 1 image (lossy)...", output
  end
end
