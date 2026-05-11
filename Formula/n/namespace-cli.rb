class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.510",
      revision: "820f9ad7f5975e9daa1a570ca68ae5099076b1cd"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d592922beec23acbbea398096db828bccae4a6afb19a8c2d59a990dc9863c32f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cdafe14813b724eeb855a4a5c86c87b9b9725adcfc95f5e8ebd54801e83ab7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3d7773fbaaebf295da3b2445d0cb4f946b7b23007063389e6a0fd313bad804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "632f10e582280d9ffe340e613defc49ec839ed6bfb1ed7354ffba4f6809ee69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1635183df4718c04576a6d09562d55d78509668caeb19b2bba47ec09b5bb9e9a"
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
