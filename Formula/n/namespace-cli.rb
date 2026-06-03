class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.518",
      revision: "2c4294aaf9873f0d8b51e5611df191356591a363"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "351724da194e6bb371ac8d8919dc7d32431c2f43d6ff5180c64ba18d07174341"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "154fafd78bcd70d0328e719d97edca21481afccbe5e568fd8b4b1a9bef33a01a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e9b2b3af1343d06f68ca2a597e5b53ef8ff631af59706778468e4550154eb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e26a604a84aa743539636a3c448b9d00bd91222ce78763427d616bd745cc2ad8"
    sha256 cellar: :any,                 x86_64_linux:  "63552ee8d95597556aab4e72a71134abda21e3b072fb9f079913d42944a93594"
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
