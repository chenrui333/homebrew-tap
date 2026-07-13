class Optimizt < Formula
  desc "CLI image optimization tool"
  homepage "https://github.com/343dev/optimizt"
  url "https://registry.npmjs.org/@343dev/optimizt/-/optimizt-13.0.0.tgz"
  sha256 "6880d0574fa58a7601253771db919e624a68825d74714633e97fea9a36faf28d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "0dcf3f33fb74290cfd79b8e70bb1d1aac8ad173f737cdc7c11dd00c9a05b1399"
    sha256 cellar: :any, arm64_sequoia: "766bdedad44bd16da530197395e963a2bfe31f0eaf2f09c7bf9102ed213104d8"
    sha256 cellar: :any, arm64_sonoma:  "766bdedad44bd16da530197395e963a2bfe31f0eaf2f09c7bf9102ed213104d8"
    sha256 cellar: :any, arm64_linux:   "a13f819406a6928261b758c92a1e8891ada69d49240db9f1bd4497cf4264b72b"
    sha256 cellar: :any, x86_64_linux:  "fd43f900be2168b129bc78de25a09f89b9dda750c576ea4ff1bbb2a213013357"
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
