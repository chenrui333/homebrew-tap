class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.11.0.tgz"
  sha256 "98db7e43ec9d143745ceb9c60745dc764035b9822ad7670ecef044437f99681a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76772d923eda2afdbd12f16fbb55036fbd2af53f50f80c8f689b717562109fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97aee7da53749cee869de7ec23f71e8e4d42dda3ed8c056623da3b38e684beae"
    sha256 cellar: :any_skip_relocation, ventura:       "609f81c96971d3b406fe8a29ae3b24ef08837a978463a49c11cc193e2e0f24dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01cae3285c3e266f39fc1f7559afe7db977d02a9b691606950a10ec16726ec2"
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
