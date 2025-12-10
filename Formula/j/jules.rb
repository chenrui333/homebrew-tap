class Jules < Formula
  desc "Asynchronous coding agent from Google, in the terminal"
  homepage "https://jules.google/docs"
  url "https://registry.npmjs.org/@google/jules/-/jules-0.1.41.tgz"
  sha256 "d8d1be85d0727bf3ec428eacad0c513e0d374bbeb5d0c7e50e6f309cee8fadf2"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5235f32e6a1998ec1f1ece58900783db9db39201e1e9b7ff776152d2b1432f08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5235f32e6a1998ec1f1ece58900783db9db39201e1e9b7ff776152d2b1432f08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5235f32e6a1998ec1f1ece58900783db9db39201e1e9b7ff776152d2b1432f08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97c0d08bd67f5c98cba45a553a90a65c1859a2838feece1dfd692373c7c3aef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9bb6c6481ba4920072b90cf8cfc9d4fd9f3a6286b01ee576740bb3f248d3e0e"
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
