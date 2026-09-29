class Curlconverter < Formula
  desc "Transpile curl commands into Python, JavaScript and 27 other languages"
  homepage "https://curlconverter.com/"
  url "https://registry.npmjs.org/curlconverter/-/curlconverter-4.12.0.tgz"
  sha256 "16b6edc240fc096f09d4bcedf1358c74fb2ea1fd94f18820ef429af98acb49d3"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5df8c0ae872dc300a5701f98e9e7fb357967bab58c0cf423b5b05e20c8a7507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3c09d194bfb7d7524a6416fd9b1b504333aecfab5a2ffe51bc660fdbb33b5e"
    sha256 cellar: :any_skip_relocation, ventura:       "dd8ed3609fd323f2cf51599dbdd052ba718eb2ece2c77a80e1dd9df66f36f8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "935bfb5f05622835c2fd6917482c3bd4abf663d2523020ca4eb7b2f7a1fdccc1"
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
