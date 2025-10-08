class Pluqqy < Formula
  desc "Terminal-based context management for AI driven development"
  homepage "https://pluqqy.com/"
  url "https://github.com/pluqqy/pluqqy-terminal/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ea69eefa597a87f715f57cfbee3cf82cb7cd8e74ba0517b8194affefa3a55e2f"
  license "MIT"
  revision 1
  head "https://github.com/pluqqy/pluqqy-terminal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb88c7712b7bc0df96329675a6e49c6d0c41db71b2b2ab2ac3ec2dc1fc39e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ae2a49b7039bcc55dde1262f778cd17114ff8a93282e73b21baccd9ad954676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52847b8663d84a1241418e6546b20cff6d5f7334d199b14110a556dc9105e2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982b56f56c37bde3253eaa68fbf7fac84121434cc87ae13fdaac03c168b48d5b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/pluqqy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluqqy version")

    output = shell_output("#{bin}/pluqqy init")
    assert_match "Initializing Pluqqy project in #{testpath}", output
    assert_path_exists testpath/".pluqqy"

    assert_match "No items found", shell_output("#{bin}/pluqqy list")
  end
end
