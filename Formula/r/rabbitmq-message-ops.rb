class RabbitmqMessageOps < Formula
  desc "CLI tool for RabbitMQ message management"
  homepage "https://github.com/happening-oss/rabbitmq-message-ops"
  url "https://github.com/happening-oss/rabbitmq-message-ops/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3aa0b65873ea3fc0aa769abc5cb03934c4cb432ae4828f36b09b6d2a5621c06"
  license "MIT"
  head "https://github.com/happening-oss/rabbitmq-message-ops.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0bb10977dfb31f3b237c6e20e12eefd59dbe881ff2b5cc365bedfb04ba908b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f09b170a188eecc886de62d4dfe545a1d55b0623f10f8adcaa13df499f47c18c"
    sha256 cellar: :any_skip_relocation, ventura:       "478c8508c21890286d6aa96f873b6c23ba995d949463ed74aacdd2c8b7ff3617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1274ac5761f7b29fec38164eaffb0a836bd55759b7f66cef05014ccc1e3aed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    system bin/"rabbitmq-message-ops", "--help"

    ENV["RABBITMQ_ENDPOINT"] = "http://localhost:15672"
    ENV["RABBITMQ_HTTP_API_ENDPOINT"] = "http://custom-api-server:15672"

    output = shell_output("#{bin}/rabbitmq-message-ops -q testqueue view 2>&1", 1)
    assert_match "publisher: failed to connect to RabbitMQ", output
  end
end
