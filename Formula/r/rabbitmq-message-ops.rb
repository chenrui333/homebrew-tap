class RabbitmqMessageOps < Formula
  desc "CLI tool for RabbitMQ message management"
  homepage "https://github.com/happening-oss/rabbitmq-message-ops"
  url "https://github.com/happening-oss/rabbitmq-message-ops/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3aa0b65873ea3fc0aa769abc5cb03934c4cb432ae4828f36b09b6d2a5621c06"
  license "MIT"
  head "https://github.com/happening-oss/rabbitmq-message-ops.git", branch: "master"

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
