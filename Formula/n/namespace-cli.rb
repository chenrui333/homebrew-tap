class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.468",
      revision: "42c6c91ec68660b107fdad5c1bb3d2325180250d"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03d1a0ce79225f1c4249715d8aaeba85f4db3101eaa6880f9ee26b891e916ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03d1a0ce79225f1c4249715d8aaeba85f4db3101eaa6880f9ee26b891e916ea6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03d1a0ce79225f1c4249715d8aaeba85f4db3101eaa6880f9ee26b891e916ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec172b541ae4902d5c94fabb4f3f1fe4c0567d502120832f4d340c07806c7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4f1f6979dbcc59ad53f395b86bbf69ad86de6a3731011d7189286b785bfc99"
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
