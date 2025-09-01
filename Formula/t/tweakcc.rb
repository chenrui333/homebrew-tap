class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.2.5.tgz"
  sha256 "930831dc25d292edcb930dc529c6cf779abb220f74678146b6e5506b93cf8d80"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b946eb840a8d3ef265e9493734c741669200f7b59e9a19a619d2aad8f6ff7ed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b69fc99f8d26e88bb6530ed8078e30120a9982e23afcc4e50ce10615a2a967c"
    sha256 cellar: :any_skip_relocation, ventura:       "1bb8ace999151e3548ea37b84da546909fc4603e5029657c9d833684da3cc753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207512a3b32cbc15fbb28ea399d9524da472a4e7e76623800de1862c76114a46"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
