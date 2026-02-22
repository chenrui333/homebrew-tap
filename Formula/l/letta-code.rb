class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.3.tgz"
  sha256 "12fc60eed05337b06075b37ca295458ea10206bd0f8a8359ecb473bbda408009"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", "--legacy-peer-deps", "--include=optional", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    ENV["HOME"] = testpath
    output = shell_output("#{bin}/letta --info")
    assert_match "Letta Code #{version}", output
    assert_match "Locally pinned agents: (none)", output
  end
end
