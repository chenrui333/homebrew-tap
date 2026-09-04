class Ccstatusline < Formula
  desc "Beautiful highly customizable statusline for Claude Code CLI"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.29.tgz"
  sha256 "dc580be15d04378711f2e15f0d7678ce14aa0dcb7b20e557a89b0d942a0679e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "604083599ff788c9b9d6884292f2022dc7153b56efd74adff81696c9532d686f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    payload = <<~JSON
      {
        "session_id": "brewtest",
        "cwd": "#{testpath}",
        "model": { "display_name": "Sonnet 4.5" },
        "version": "2.0.0",
        "cost": { "total_cost_usd": 0.01, "total_duration_ms": 1000 },
        "context_window": { "used_percentage": 12 }
      }
    JSON

    output = pipe_output(bin/"ccstatusline", payload)
    assert_match "Model:", output
    assert_match "Sonnet", output
  end
end
