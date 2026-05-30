class Claws < Formula
  desc "Terminal UI for AWS resource management"
  homepage "https://github.com/clawscli/claws"
  url "https://github.com/clawscli/claws/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "93fc3bde4409475ae48d8924dfaccff5b231d0a5cb36034b81b556b361bed1e0"
  license "Apache-2.0"
  head "https://github.com/clawscli/claws.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "425b187ccc4b96f3ca312162f1565099117dd0e421fe43ceab0f2bcf47c9e486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425b187ccc4b96f3ca312162f1565099117dd0e421fe43ceab0f2bcf47c9e486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425b187ccc4b96f3ca312162f1565099117dd0e421fe43ceab0f2bcf47c9e486"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "437d4b2a5335296488eb4077773b091efb614d5ce030c04736e5a909b3a9304b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3c9ed433c26d7d6153c81b5384e4cb0948380aa5946f4e8658c8e1ab79fbb4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"claws"), "./cmd/claws"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claws --version")

    output = shell_output("#{bin}/claws --profile invalid/name 2>&1", 1)
    assert_match "Error: invalid profile name: invalid/name", output
    assert_match "Valid characters: alphanumeric, hyphen, underscore, period", output
  end
end
