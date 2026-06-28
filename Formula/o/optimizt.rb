class Optimizt < Formula
  desc "CLI image optimization tool"
  homepage "https://github.com/343dev/optimizt"
  url "https://registry.npmjs.org/@343dev/optimizt/-/optimizt-13.0.0.tgz"
  sha256 "6880d0574fa58a7601253771db919e624a68825d74714633e97fea9a36faf28d"
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

    # Avoid loading the native image stack for metadata-only CLI commands.
    cli = libexec/"lib/node_modules/@343dev/optimizt/cli.js"
    inreplace cli, "import optimizt from './index.js';\n", ""
    inreplace cli, "} else {\n", <<~JS
      } else {
      \tconst { default: optimizt } = await import('./index.js');
    JS

    node_modules = libexec/"lib/node_modules/@343dev/optimizt/node_modules"
    {
      "@343dev/gifsicle" => formula_opt_bin("gifsicle")/"gifsicle",
      "@343dev/guetzli"  => formula_opt_bin("guetzli")/"guetzli",
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

    output = shell_output("#{bin}/optimizt --definitely-invalid 2>&1", 1)
    assert_match "unknown option", output
  end
end
