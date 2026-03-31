class Tori < Formula
  desc "Remote Docker and host monitoring over SSH"
  homepage "https://toricli.sh/"
  url "https://github.com/thobiasn/tori-cli/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "c432d112ac8f10c6024fb76211429ea62a961f6cb12dc722322da43d478ccb79"
  license "MIT"
  head "https://github.com/thobiasn/tori-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d5a0d21c0df5706ec006dc52e442ca2e0165e2e309403e9f6091d6e7aca9a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48d5a0d21c0df5706ec006dc52e442ca2e0165e2e309403e9f6091d6e7aca9a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d5a0d21c0df5706ec006dc52e442ca2e0165e2e309403e9f6091d6e7aca9a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "706c662f04fc95f695b82067234d97ad6d1c6bc8ced345b2d42e720532e24217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4199838891bd783e4f57e848207d4d5c5e26165a286a48ca887a59f2f6578a2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tori"
  end

  test do
    output = shell_output("XDG_CONFIG_HOME=#{testpath} #{bin}/tori 2>&1", 1)
    assert_match "No servers configured", output

    socket_output = shell_output("#{bin}/tori --socket #{testpath}/missing.sock 2>&1", 1)
    assert_match "connect:", socket_output
  end
end
