class Retype < Formula
  desc "Static site generator that builds a website based on simple text files"
  homepage "https://retype.com/"
  url "https://registry.npmjs.org/retypeapp/-/retypeapp-3.6.0.tgz"
  sha256 "c8e87286860bf4c65f42927c8b723ec6b6251861d2d396a9b2d5702724b6f5ca"
  # Retype Software License Agreement

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retype --version")

    system bin/"retype", "init", "test_project"
    assert_match "output: .retype", (testpath/"test_project/retype.yml").read

    cd "test_project" do
      system bin/"retype", "build"
    end

    assert_path_exists testpath/"test_project/.retype/index.html"
    assert_match <<~EOS, (testpath/"test_project/.retype/robots.txt").read
      User-agent: *
      Allow: /

      Sitemap: /sitemap.xml.gz
    EOS
  end
end
