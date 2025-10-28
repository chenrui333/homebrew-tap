class Jules < Formula
  desc "Asynchronous coding agent from Google, in the terminal"
  homepage "https://jules.google/docs"
  url "https://registry.npmjs.org/@google/jules/-/jules-0.1.38.tgz"
  sha256 "5a7ef1c25e3e58ecb5518c866f644ca4bcf6fda312688c20d7fbc5adfc79cba6"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4881053ca8217520d8815742cfb5338843ad2724e3474459e5151fdad3b0ba1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4881053ca8217520d8815742cfb5338843ad2724e3474459e5151fdad3b0ba1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4881053ca8217520d8815742cfb5338843ad2724e3474459e5151fdad3b0ba1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d742a2a133601d6a527b5490fa2198e2bf5f524cd0cd9fecaca35db2a4131df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91e9ff35ec0a7e2913bcefbdc869888d29c635d8b53e3b4b9882664b13d98a1d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(bin/"jules", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jules version")

    assert_match "Error: failed to list repos", shell_output("#{bin}/jules remote list --repo 2>&1")
  end
end
