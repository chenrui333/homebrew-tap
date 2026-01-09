class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.470",
      revision: "f7dbe7f43b08cb0fc6342b5fc296f0701980a6a3"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd0e95f48b0ff19a83099410b07f0fb8fd18371b3618ddce449eb957bd38fdbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd0e95f48b0ff19a83099410b07f0fb8fd18371b3618ddce449eb957bd38fdbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd0e95f48b0ff19a83099410b07f0fb8fd18371b3618ddce449eb957bd38fdbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "176d3befc701f1f0620c087e498cc12281858bb08c25a528a1da25e66a1466c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d7b6e96040093613041162311d5468711f4596fd243221d5faf8408cf89c58"
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
