class Ccstatusline < Formula
  desc "Beautiful highly customizable statusline for Claude Code CLI"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.25.tgz"
  sha256 "83850d8591e909e4ded6293b4f9d20663b3103ed7fe4f01b171ba8dcf7bf3c94"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "09b0fbb4a3ceedbe516670ca60afef937a25dfc54cac02aeae80e41ce1494785"
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
