class Pdfvision < Formula
  desc "Extract text, metadata, layout, and images from PDFs for AI agents"
  homepage "https://pdfvision.dev/"
  url "https://registry.npmjs.org/pdfvision/-/pdfvision-0.16.0.tgz"
  sha256 "c5e13f90012cc61cbe065f92f3a932a34ed987422384a37063062bd8e3168e86"
  license "MIT"
  head "https://github.com/yamadashy/pdfvision.git", branch: "main"

  depends_on "node"

  deny_network_access!

  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devDependencies")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    prepare_package_json
    rm_r buildpath/"npm-fetch" if (buildpath/"npm-fetch").exist?
    system "npm", "install", "--offline", *std_npm_args

    node_modules = libexec/"lib/node_modules/pdfvision/node_modules"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}#{"-gnu" if OS.linux?}"
    node_modules.glob("**/@napi-rs/canvas-*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "canvas-#{native}"
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfvision --version")

    cp test_fixtures("test.pdf"), testpath/"test.pdf"
    output = shell_output("#{bin}/pdfvision test.pdf --json --no-cache --render --render-output #{testpath}/images")
    document = JSON.parse(output)
    assert_equal 1, document.fetch("totalPages")
    assert_match "Homebrew test", document.fetch("pages").fetch(0).fetch("text")
    assert_path_exists testpath/"images/page-1.png"

    (testpath/"invalid.pdf").write "not a PDF document"
    assert_match "Invalid PDF", shell_output("#{bin}/pdfvision invalid.pdf --no-cache 2>&1", 1)
  end
end
