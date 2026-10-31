class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "0e63213ecf9d44ee35d372e1c9aec02d0547b3c58bc356e214b469dbdb44a1c0"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/plannotator-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plannotator-tui --version")

    (testpath/"plan.md").write <<~MARKDOWN
      # Release plan

      Ship the source package.
    MARKDOWN
    system bin/"plannotator-tui", "--annotate", "plan.md", "source package", "Check the license"
    output = shell_output("#{bin}/plannotator-tui --export plan.md")
    assert_match "Check the license", output
    assert_match "source package", output
  end
end
