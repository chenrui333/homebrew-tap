class Speedscope < Formula
  desc "Fast, interactive web-based viewer for performance profiles"
  homepage "https://www.speedscope.app/"
  url "https://registry.npmjs.org/speedscope/-/speedscope-1.25.0.tgz"
  sha256 "2831f1e0d26df914b477e522d78b8485511495a6af81a0b88158f8b48f9e0d03"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e79e67d6d80e9595f87136a1e051a1114c2080686122070132e215b2bfb6d779"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/speedscope --version")

    profile = testpath/"profile.speedscope.json"
    profile.write <<~JSON
      {"$schema":"https://www.speedscope.app/file-format-schema.json","shared":{"frames":[{"name":"main"}]},
       "profiles":[{"type":"evented","name":"brew","unit":"none","startValue":0,"endValue":1,
       "events":[{"type":"O","frame":0,"at":0},{"type":"C","frame":0,"at":1}]}]}
    JSON

    output = shell_output("#{bin}/speedscope #{profile}")
    js_file = output[/Creating temp file (\S+\.js)$/, 1]
    assert_match [profile.read].pack("m0"), File.read(js_file)
  end
end
