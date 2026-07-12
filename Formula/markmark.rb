class Markmark < Formula
  desc "Markdown language tooling, exposed as a language server"
  homepage "https://github.com/nikku/markmark"
  url "https://registry.npmjs.org/markmark/-/markmark-0.7.0.tgz"
  sha256 "3707611eb07a0f26094e8a0816f7273d24f451490c245bf68078686ba5ab7f9e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "321f720d2ffb1220d81045e808e92381586d883b8928867c8b3cc88515676a10"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  { rootUri: nil, capabilities: {} },
    }.to_json

    Open3.popen3(bin/"markmark-lsp", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{request.bytesize}\r\n\r\n#{request}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
