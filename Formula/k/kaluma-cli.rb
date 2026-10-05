class KalumaCli < Formula
  desc "CLI to program devices and boards running Kaluma runtime"
  homepage "https://kalumajs.org/"
  url "https://registry.npmjs.org/@kaluma/cli/-/cli-1.4.0.tgz"
  sha256 "b5d144ced6b9d210c4e49256bb49deaba573cd8e3458fd03261553ab061c6f92"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c5e95b58fa8daf5b073befe23317279a1c0825bd753463eb4120d7df1861e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "155f6687f50e5ccae5d2a253b18f86ec579d4371875bb9f4e6e19419dad6ba02"
    sha256 cellar: :any,                 arm64_linux:   "08f2b75999888a336396429775a6330fde903bdc95c3fe1df2bd63672500f4d1"
    sha256 cellar: :any,                 x86_64_linux:  "784fb43067111d22388997e14efff30426d4d9cafdd7c5ebf6cecc5ec1f3f0ec"
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
    rm_r buildpath/"npm-fetch"
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
