class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.494",
      revision: "0e82a0568529bac1a19281040657021280763cdb"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "600ea6393d2a91a840a8a362ca2bba627d8a5b2ee7e7082f067894d4d061d65d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "600ea6393d2a91a840a8a362ca2bba627d8a5b2ee7e7082f067894d4d061d65d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "600ea6393d2a91a840a8a362ca2bba627d8a5b2ee7e7082f067894d4d061d65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f06201339470cf14b07c7e2163e1b1c68bc0ddb7d7ab2d8901426d5f7c88af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493a288c8c16366f3bf4f7c12a45e0a492e127ebbf80b700fecd2d386db64843"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "failed to get authentication token", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
