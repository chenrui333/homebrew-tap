class Ccstatusline < Formula
  desc "Beautiful highly customizable statusline for Claude Code CLI"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.23.tgz"
  sha256 "696fb5d5f83c8f5a1ca799d29b0a1c4dc4a48edde7b49be395a4a1f3b8b73e25"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "83fad65d2379cb8e0355fb205e89d9732b62b843db28ff37c13947d8487a6a6e"
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
