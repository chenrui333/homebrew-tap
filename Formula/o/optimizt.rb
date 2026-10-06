class Optimizt < Formula
  desc "CLI image optimization tool"
  homepage "https://github.com/343dev/optimizt"
  url "https://registry.npmjs.org/@343dev/optimizt/-/optimizt-13.0.0.tgz"
  sha256 "6880d0574fa58a7601253771db919e624a68825d74714633e97fea9a36faf28d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "cec93adb921a7730ead8713075c5a4d6fbd37321efa8c39c06c40f6f77a53336"
    sha256 cellar: :any, arm64_sequoia: "cec93adb921a7730ead8713075c5a4d6fbd37321efa8c39c06c40f6f77a53336"
    sha256 cellar: :any, arm64_linux:   "4501a28918b397014b6c9c360a12bf6e1f1a96526811a6b5aa896dde494ce3c0"
    sha256 cellar: :any, x86_64_linux:  "19b14982100e199e454dbc137ba123417e80d1a7c31edadb3983be9fbcb3061f"
  end

  depends_on "gifsicle"
  depends_on "guetzli"
  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

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
