class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.544",
      revision: "16b2db25392480d02479c72db95a74b9c0354710"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1cee9f9630f75522c4b8258c2e0bb995f0cc90e1c1827bc2e39f832e00b761c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1cee9f9630f75522c4b8258c2e0bb995f0cc90e1c1827bc2e39f832e00b761c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1cee9f9630f75522c4b8258c2e0bb995f0cc90e1c1827bc2e39f832e00b761c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0939e732b66a18168d28137298441771364b586b7660243e919ae398f4a29deb"
    sha256 cellar: :any,                 x86_64_linux:  "3077c4a4bab30bdc31346df3ada727005760c17ca179b87d61107107c46932e1"
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
