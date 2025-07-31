class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.17.4.tgz"
  sha256 "0e4e61e8b8a05bc91e34da4cdac6c8843a0f5df1de7ea156886741ef73ce291d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03741fe7256de5b32393a4d211830c8ee990bc755a6a5745bc215eb11ce25f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d559e7457aaa3a93f0b7095fd29e6fddcc7d01c0eafd11a4b9fc6aa4268d1be1"
    sha256 cellar: :any_skip_relocation, ventura:       "de4722dfdd6091024c82f39413917b07fb488583be745a181a06fb42cf735451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8281fb87ec49e850eb53941699793e8ba219969fea719f4061ff61ff038dc678"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")

    assert_match "Not logged in", shell_output("#{bin}/eas whoami 2>&1", 1)
    output = shell_output("#{bin}/eas config 2>&1", 1)
    assert_match "Run this command inside a project directory", output
  end
end
