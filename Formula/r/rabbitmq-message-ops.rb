class RabbitmqMessageOps < Formula
  desc "CLI tool for RabbitMQ message management"
  homepage "https://github.com/happening-oss/rabbitmq-message-ops"
  url "https://github.com/happening-oss/rabbitmq-message-ops/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3aa0b65873ea3fc0aa769abc5cb03934c4cb432ae4828f36b09b6d2a5621c06"
  license "MIT"
  head "https://github.com/happening-oss/rabbitmq-message-ops.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91c7ca4049dd722fda8404ac4047061790a7ddc893d846c52e1ab52a92fc1f7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91c7ca4049dd722fda8404ac4047061790a7ddc893d846c52e1ab52a92fc1f7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f77359981f8a6afb3ef7004ab5b80f7a2de19b69d61834987b84ebf4fc7779"
    sha256 cellar: :any,                 x86_64_linux:  "fcf43e242f9982f2f180245cdddabcdec775000971be530491476c9596c4302d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    # Both errors are raised while parsing CLI input, before any broker connection is attempted
    ENV["RABBITMQ_ENDPOINT"] = "amqp://guest:guest@localhost:5672/"
    output = shell_output("#{bin}/rabbitmq-message-ops -q testqueue -v debug view 2>&1", 1)
    assert_match "unsupported verbosity level", output

    ENV["RABBITMQ_ENDPOINT"] = "amqp://localhost:5672/%zz"
    output = shell_output("#{bin}/rabbitmq-message-ops -q testqueue view 2>&1", 1)
    assert_match "invalid URL escape", output
  end
end
