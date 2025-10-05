class Optimizt < Formula
  desc "CLI image optimization tool"
  homepage "https://github.com/343dev/optimizt"
  url "https://registry.npmjs.org/@343dev/optimizt/-/optimizt-12.1.1.tgz"
  sha256 "eb7fbfe1cacbc61eecf9fa598d4e09d25448827246e00a999553da779ba4d1d2"
  license "MIT"

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
