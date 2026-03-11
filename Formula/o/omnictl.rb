class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.10.tar.gz"
  sha256 "d27977db1b154b78be6726d4f1951d61eb1727b9f2c4640b99739827e624fdf0"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef2b524ce32ddcc5c31674d7251c1820a8cddbffd543e66da406f2e3372b42ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2b524ce32ddcc5c31674d7251c1820a8cddbffd543e66da406f2e3372b42ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2b524ce32ddcc5c31674d7251c1820a8cddbffd543e66da406f2e3372b42ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50fe1e74d13dd5333ab659dd97c7bb8e9128452aa3fd07b1522f387feb839434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e82d5dc1acddac0697ea9ff7273fbf7e8fb42ac1d6724daf6907ed7d055975"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/omnictl --version")
    system bin/"omnictl", "--version"

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
