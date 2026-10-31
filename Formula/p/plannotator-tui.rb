class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "0e63213ecf9d44ee35d372e1c9aec02d0547b3c58bc356e214b469dbdb44a1c0"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8583524059d4b6b4eee7763cbd9ff017aacf188a904936791be9976e78caaf82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1e91be85d8660e72ebf57a4eb821448e7b41ae07e2bfdaac8d39dda8fe64cfe"
    sha256 cellar: :any,                 arm64_linux:   "55a64960306412e1cc3880dade00370a1b590f7232082dd7cbe75917c14dc25c"
    sha256 cellar: :any,                 x86_64_linux:  "6aa45fe6e1a8e3f43a8777f5a7b96c384f35143878f455835dcb11af8a6edef7"
  end

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
