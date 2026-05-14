class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.514",
      revision: "4e56f194776a2a1e02a1e33bf21cac0989d85c7b"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "469e63c1584176240d0118745c8df784a86d65aa75e97613b7900ae6dd92c79c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b0975156c4557bae20c8f045f32a8cecb19f7166022d96a0f6117832ff384e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e664b2245f7a6ba78b6f1bdf1e7b69eaae469a475e53a635e0582ab7204cd98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da48139a7f2748e9b3e026d6485a6fde7a1e5450ffad4e2413c6c5350d5b7d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7ebe401b1b6e96c4d05a750143a5a23ad11bd36f7073cc12d3e11c73daf242"
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
