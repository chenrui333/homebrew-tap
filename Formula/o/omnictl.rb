class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.48.4.tar.gz"
  sha256 "5516ae79a19501a9e72d08aa9e582292ec926012251b93037e7346c45f042f7e"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cd3acd5338a13c040f4349a2424ca48e3124ae56d1e1fde697d0b12aa6a5ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57aeba47bd55a133f362d26b76a421360f56427e5802b0c71f964df9f6c3e209"
    sha256 cellar: :any_skip_relocation, ventura:       "009b46192b9b3bb1431c762d097e58c12bde2845a37e52b1eaa562df07594299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62c4207a9c17743d1cb9b06e765ede1a953ec0c67256f00d75c65ddc12228835"
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
