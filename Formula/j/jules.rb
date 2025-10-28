class Jules < Formula
  desc "Asynchronous coding agent from Google, in the terminal"
  homepage "https://jules.google/docs"
  url "https://registry.npmjs.org/@google/jules/-/jules-0.1.38.tgz"
  sha256 "5a7ef1c25e3e58ecb5518c866f644ca4bcf6fda312688c20d7fbc5adfc79cba6"
  # license :unfree

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
