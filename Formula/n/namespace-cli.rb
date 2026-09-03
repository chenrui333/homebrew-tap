class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.563",
      revision: "45eefa04667b6672c9e685bd61fc69b3c340b351"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5fc6f8eec8e150e913bf8bee7b4173059b715cb709c06b47f93f1f095823cf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5fc6f8eec8e150e913bf8bee7b4173059b715cb709c06b47f93f1f095823cf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5fc6f8eec8e150e913bf8bee7b4173059b715cb709c06b47f93f1f095823cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da90d34e2a51261261c3b97308c9037874331da42030df645824713a907c5ef7"
    sha256 cellar: :any,                 x86_64_linux:  "1218f088bc3f021a19dceee66fe3a7f346c2b75e010e4f029a83ebe2535912ef"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
