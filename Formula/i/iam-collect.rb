class IamCollect < Formula
  desc "Collect IAM information from all your AWS organization, accounts, and resources"
  homepage "https://github.com/cloud-copilot/iam-collect"
  url "https://registry.npmjs.org/@cloud-copilot/iam-collect/-/iam-collect-0.1.179.tgz"
  sha256 "05e083c1840d2aea7babb96544242ef63f23d51761b23627a29f14b9a7aedaa7"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a790f84d3a4575b69ff3620223b121cacf6ca85bc39eecec2a2a9912919d35d5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iam-collect --version")

    system bin/"iam-collect", "init"
    assert_path_exists testpath/"iam-collect.jsonc"

    assert_match "Could not load credentials from any providers", shell_output("#{bin}/iam-collect download 2>&1", 1)
  end
end
