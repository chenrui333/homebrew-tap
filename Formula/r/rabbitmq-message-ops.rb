class RabbitmqMessageOps < Formula
  desc "CLI tool for RabbitMQ message management"
  homepage "https://github.com/happening-oss/rabbitmq-message-ops"
  url "https://github.com/happening-oss/rabbitmq-message-ops/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3aa0b65873ea3fc0aa769abc5cb03934c4cb432ae4828f36b09b6d2a5621c06"
  license "MIT"
  head "https://github.com/happening-oss/rabbitmq-message-ops.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c11feae1514e3c1ef7c982653965ffc82b691644289a529a804b4e87d1823618"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c11feae1514e3c1ef7c982653965ffc82b691644289a529a804b4e87d1823618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c11feae1514e3c1ef7c982653965ffc82b691644289a529a804b4e87d1823618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3600a4ee6f91c5bb2b4dd9af75f3489101baf76a5e2c27fdcaf72769c924fc4a"
    sha256 cellar: :any,                 x86_64_linux:  "78b5e05e7df3196f372231a93e3e33b7dbae19dae161cec1ab575a8b7921c5e0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    ENV["RABBITMQ_ENDPOINT"] = "http://localhost:15672"
    ENV["RABBITMQ_HTTP_API_ENDPOINT"] = "http://custom-api-server:15672"

    output = shell_output("#{bin}/rabbitmq-message-ops -q testqueue view 2>&1", 1)
    assert_match "publisher: failed to connect to RabbitMQ", output
  end
end
