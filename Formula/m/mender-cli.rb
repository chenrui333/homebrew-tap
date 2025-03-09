class MenderCli < Formula
  desc "General-purpose CLI for the Mender backend"
  homepage "https://github.com/mendersoftware/mender-cli"
  url "https://github.com/mendersoftware/mender-cli/archive/refs/tags/1.12.0.tar.gz"
  sha256 "7b68fdeef96a99ee4560cb9dccd673658b27e2f3a9be2e3451d204c50395caa0"
  license "Apache-2.0"
  head "https://github.com/mendersoftware/mender-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "452737a148a60c2b71458af18a6c80c65c73cf8093b601b5cac792a2ed759bc7"
    sha256 cellar: :any,                 arm64_sonoma:  "ba6516743bf015cce805a9923ec17996064f718af99afd77e5d977f3ffa6e2e2"
    sha256 cellar: :any,                 ventura:       "e83fbdede7d3bc242ec20b025fafa669b90ce8f1365dcc462e872f40cd32cea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "548f5afa52846eda36b7ab9f8868b2dbb5f6a1c9e62f1cd5a057c49db0d1dbfb"
  end

  depends_on "go" => :build
  depends_on "xz" # required for lzma support

  def install
    ldflags = %W[
      -s -w
      -X github.com/mendersoftware/mender-cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mender-cli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mender-cli --version")

    output = shell_output("#{bin}/mender-cli devices list 2>&1", 1)
    assert_match "FAILURE: Please Login first", output
  end
end
