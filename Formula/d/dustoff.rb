class Dustoff < Formula
  desc "Find and remove JS/TS build artifacts wasting disk space"
  homepage "https://github.com/westpoint-io/dustoff"
  url "https://github.com/westpoint-io/dustoff/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "800a7aefaabde74db65bd2ea8ed49e39a48bc52cae43f59ce234422f39f41b27"
  license "MIT"
  head "https://github.com/westpoint-io/dustoff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5841ad1c971e8b3a1732bec0e0de9e7ea26c23e275e84f04c296140e4d40d072"
  end

  depends_on "chenrui333/tap/bun" => :build
  depends_on "node"

  def install
    inreplace "package.json", '"version": "0.1.0"', "\"version\": \"#{version}\""

    system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)
    system "bun", "run", "build"
    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dustoff --version")

    (testpath/"demo/node_modules/foo").mkpath
    (testpath/"demo/node_modules/foo/index.js").write "module.exports = 1;\n"

    ENV["TERM"] = "xterm-256color"
    cmd = if OS.mac?
      "sh -c '(sleep 2; printf q) | script -q /dev/null " \
        "#{bin}/dustoff --directory #{testpath}/demo --target node_modules'"
    else
      "sh -c '(sleep 2; printf q) | script -q -c " \
        "\"#{bin}/dustoff --directory #{testpath}/demo --target node_modules\" /dev/null'"
    end

    output = shell_output(cmd)
    assert_match(/\e\[2J/, output)
    assert_operator output.bytesize, :>, 100
  end
end
