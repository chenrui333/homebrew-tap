class Ccstatusline < Formula
  desc "Beautiful highly customizable statusline for Claude Code CLI"
  homepage "https://github.com/sirmalloc/ccstatusline"
  url "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.26.tgz"
  sha256 "e63fc00bc096e263be4052d625f55aed7822df8df140bb7d7cf771744f71c187"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9d6433098ebd7d81860b39536302f2df34bd6c4250f3641738e6ae859be06a2c"
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
