class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "d6a48cdca59545b8253f71e12bb0aaef06319a293d01bdd900197966c6f81934"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64b7c2ef4585d0656235e0eaebcda44b9ced05a7f610867652eebb23d50e54b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4148c72d23cb4d25060bc54513494e813fec711d65e854e6062b84ef121ae37d"
    sha256 cellar: :any_skip_relocation, ventura:       "9f050c6129fab4be86bccd2da69751ce2de139e2834b66dfcb2181b386328614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94af3b28b28371f71ad300c9be1222ed43af64074f9da45ea9112bed2bfa43eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
