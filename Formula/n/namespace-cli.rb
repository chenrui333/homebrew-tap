class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.515",
      revision: "458a655da2281e151a9743217f7a22bc9ae1ebf1"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d68a110727972f72d4e3d63ed4bd44888b5be5d4aa7a77e50ffb9b105b4a5194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ec6a21a4778f29eb80a2c6a51e592ecdd4550769c433c2f80a08ffd54251a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38bf15775f7dcf353bd5c5d9eb2a7f5ebe53e13ad4df58ae5afe5a23b863d501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4687f2652eb08efa3aade9c3b22f06cae985097ef4ff88b5e418a8170bc3c812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a26bed9f97bbc095576ba8f00068457f6db8f1aab3e769099a133798c5487c"
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
