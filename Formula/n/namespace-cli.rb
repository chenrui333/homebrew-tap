class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.461",
      revision: "b2d4890c7c4e2ec154852cf8c6dda067b6165e7b"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ee94bc0adf944d36f26bb04e28ebbab9200cf2b62461d1d8739befda5096290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ee94bc0adf944d36f26bb04e28ebbab9200cf2b62461d1d8739befda5096290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ee94bc0adf944d36f26bb04e28ebbab9200cf2b62461d1d8739befda5096290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ae2fa82cd4d025221d64f526b934e17865017068582357e0b6ca4e490c9351b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6faec0a7243423c3d317f150e0b3895b1a46c72ba49aa3b42d5b8deca48e00"
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
