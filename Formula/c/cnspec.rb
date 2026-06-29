class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.25.0.tar.gz"
  sha256 "5db71412ece8a4b2e522e6ee213e33c98219c8fdca4f3123b61e155ce4e44389"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e8612e080ba5d51b57563b7720e8e6a7b79cebc136adc19bd72ad50ff39403b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918d7c0545db58c0ba7debb782bc49ddd694514dc340bf44419d83cce88e6698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd0dc90b1ce242c1f6dd94c591c2b7126fa0c80f89b8944ad58997329490af4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be952722091adfa86f085102547fc10f18d30677e558ce7159224f462f11c20a"
    sha256 cellar: :any,                 x86_64_linux:  "e86ec8d35f28d83ee980b8ac9a7428b0417388ae65af39052be27198e5c62e15"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
