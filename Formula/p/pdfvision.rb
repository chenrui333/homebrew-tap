class Pdfvision < Formula
  desc "Extract text, metadata, layout, and images from PDFs for AI agents"
  homepage "https://pdfvision.dev/"
  url "https://registry.npmjs.org/pdfvision/-/pdfvision-0.18.0.tgz"
  sha256 "f05b35778252ba1cf24b9998940dd2920e9da6da786ca330a070857c3b97858c"
  license "MIT"
  head "https://github.com/yamadashy/pdfvision.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c76c6246d79584d60584496ec1e84e03f0406b4f07f81a89153fdd7d8efe22a9"
    sha256 cellar: :any,                 arm64_sequoia: "c76c6246d79584d60584496ec1e84e03f0406b4f07f81a89153fdd7d8efe22a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc04d6457bd95522491a2bd37c7a4fe6681a175897ab7505ae9300e0b7055b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "416fa589dbc6b622bebb71457582aa504b31e62724d62077c2aff95271a24005"
  end

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
