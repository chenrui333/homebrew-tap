class Curlconverter < Formula
  desc "Transpile curl commands into Python, JavaScript and 27 other languages"
  homepage "https://curlconverter.com/"
  url "https://registry.npmjs.org/curlconverter/-/curlconverter-4.12.0.tgz"
  sha256 "16b6edc240fc096f09d4bcedf1358c74fb2ea1fd94f18820ef429af98acb49d3"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e6025e372e704399cbbb68aa31eb1e28f8d39988640c173238baa8173486527"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26fe355a83146814a36d30594eef2561a361c9c3f0f4923819fbf75502b6fab7"
    sha256 cellar: :any,                 arm64_linux:   "794d68693a95310003c0e001335c8d167de4a7340d9b3c99690a52d97495c2ad"
    sha256 cellar: :any,                 x86_64_linux:  "5672818660902cd8e8e01bb3e81f1f09feb6f45c9c61c23fb6e1926220f42f82"
  end

  depends_on "python@3.14" => :build
  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/curlconverter/node_modules"
    inreplace node_modules/"tree-sitter/binding.gyp", "c++17", "c++20"
    %w[tree-sitter tree-sitter-bash].each do |name|
      cd node_modules/name do
        rm_r "prebuilds"
        system "node", formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js",
               "rebuild", "--nodedir=#{formula_opt_prefix("node")}",
               "--python=#{formula_opt_bin("python@3.14")}/python3.14"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/curlconverter --version")
    output = shell_output("#{bin}/curlconverter --language python https://example.com")
    assert_match "response = requests.get('https://example.com')", output
  end
end
