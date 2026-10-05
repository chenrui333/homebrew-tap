class KalumaCli < Formula
  desc "CLI to program devices and boards running Kaluma runtime"
  homepage "https://kalumajs.org/"
  url "https://registry.npmjs.org/@kaluma/cli/-/cli-1.4.0.tgz"
  sha256 "b5d144ced6b9d210c4e49256bb49deaba573cd8e3458fd03261553ab061c6f92"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "df8e03e595b0bffad6ad69420609e38d7a295e20f4e82c88860e63bd79361e90"
    sha256                               arm64_sonoma:  "f18c74d6a37cd3f3bee2322143da287e0e69c3741366cf6a4013e29c17ba8731"
    sha256                               ventura:       "68cdc119d79f93ebe588c9f86ea8b903069b6a1153a28b95bd5eb3d2a56a54dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feb1713936812610833366396f00a1c4ba2ba03634c3e0f121ae5079641ff6fb"
  end

  depends_on "libuv" => :build
  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    # Build serialport's native bindings from source against Homebrew node's headers;
    # brewed node uses the shared libuv, so its headers come from the libuv formula.
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    ENV.append_path "CPATH", formula_opt_include("libuv")
    system "npm", "install", "--offline", "--allow-scripts=@serialport/bindings",
           *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec/"bin/kaluma"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaluma --version")

    system bin/"kaluma", "ports"

    (testpath/"lib.js").write "module.exports = (n) => n * 2;\n"
    (testpath/"index.js").write "console.log(require(\"./lib.js\")(21));\n"
    system bin/"kaluma", "bundle", "./index.js", "--output", "bundle.js"
    assert_equal "42", shell_output("#{formula_opt_bin("node")}/node bundle.js").chomp
  end
end
