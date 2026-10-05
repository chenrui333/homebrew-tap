class KalumaCli < Formula
  desc "CLI to program devices and boards running Kaluma runtime"
  homepage "https://kalumajs.org/"
  url "https://registry.npmjs.org/@kaluma/cli/-/cli-1.4.0.tgz"
  sha256 "b5d144ced6b9d210c4e49256bb49deaba573cd8e3458fd03261553ab061c6f92"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a21916207cd9c4c2bb51df911aba424e80a0de277aa4740a147833ac6b5e1de8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a09ffa50a10a0d58d7b16222c4a2ff379bcaf02b484fc6040a9035e05413f59b"
    sha256 cellar: :any,                 arm64_linux:   "f8bb1afdcaf7d21f83db61cac584426c1f58bbc24f71a1b9e3d52a40492e2072"
    sha256 cellar: :any,                 x86_64_linux:  "94931db76811485f22253f21b8045905e052a11f66261e2dbf6e13ccf94fbbfa"
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
